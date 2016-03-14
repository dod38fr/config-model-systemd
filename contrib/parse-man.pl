#!/usr/bin/perl

use strict;
use warnings;
use 5.22.0;

use lib 'lib';

use XML::Twig;
use XXX;
use Path::Tiny;
use Config::Model::Itself;
use Config::Model::Exception;
use experimental qw/postderef signatures/ ;

my $systemd_path = path('/home/domi/debian-dev/systemd-228/man/');

Config::Model::Exception::Trace(1);

sub parse_xml ($list, $map){

    my %data = ( element => [] );
    my $config_class;

    my $desc = sub ($t, $elt) {
        my $txt = $elt->trimmed_text;
        # there's black magic in XML::Twig that trash error message
        # contained in an error object.  So the error must be stringified
        # explicitly before being sent upward

        # but it's easier to store data and handle it later outside of XML::Twig realm
        $data{class}{$config_class} //= [];
        push $data{class}{$config_class}->@*, $txt;
    };

    my $manpage = sub ($t, $elt) {
        my $man = $elt->first_child('refentrytitle')->text;
        my $nb = $elt->first_child('manvolnum')->text;
        $elt->set_text( "L<$man($nb)>");
    };

    my $variable = sub  ($t, $elt) {
        my $varname = $elt->first_child('term')->first_child('varname')->text;
        my ($name, $trash) = split '=', $varname, 2;
        say "class $config_class element $name, trashed $trash" if $trash;
        my $desc = $elt->first_child('listitem')->trimmed_text;
        $desc =~ s/(\w+)=/C<$1>/g;

        push $data{element}->@*, [$config_class => $name => $desc ];
    };

    my $set_config_class = sub ($name) {
        $config_class = 'Systemd::'.( $map->{$name} || 'Section::'.ucfirst($name));
        say "Parsing class $config_class";
    };

    my $parse_sub_title = sub {
        my $t = $_->text();
        if ($t =~ /\[(\w+)\] Section Options/ ) {
            $set_config_class->($1) ;
        }
    };
    my $twig = XML::Twig->new (
        twig_handlers => {
            'refsect1/title' => $parse_sub_title,
            'refsect1[string(title)=~ /Description/]/para' => $desc,
            'citerefentry' => $manpage,
            'literal' => sub { my $t = $_->text(); $_->set_text("C<$t>");},
            'refsect1[string(title)=~ /Options/]/variablelist/varlistentry' => $variable,
        }
    );

    foreach my $subsystem ($list->@*) {
        my $file = $systemd_path->child("systemd.$subsystem.xml");
        $set_config_class->($subsystem);
        $twig->parsefile($file);
    }

    return \%data;
}


sub setup_element ($meta_root, $config_class, $element, $desc) {

    my $value_type ;
    my $obj = $meta_root->grab(
        step => "class:$config_class element:$element",
        autoadd => 1
    );
    if ($desc =~ /Takes an? (boolean|integer)/) {
        $value_type = $1;
    }
    elsif ($desc =~ /Takes time \(in seconds\)/) {
        $value_type = 'integer';
    }

    my ($min, $max) = ($desc =~ /Takes an integer between ([-\d]+) (?:\([\w\s]+\))? and ([-\d+])/) ;

    my $vt_obj;
    if ($element =~ /^Exec/) {
        $obj->load("type=list cargo type=leaf"); # make sure that value_type is accessible
        $vt_obj = $obj->grab("cargo value_type");
    }
    else {
        $obj->load("type=leaf"); # make sure that value_type is accessible
        $vt_obj = $obj->fetch_element("value_type");
    }

    my $old_vt = $vt_obj->fetch(check => 'no') // '';
    my $type = $obj->get_type;
    if ($value_type and $value_type ne $old_vt) {
        # force type
        say "Storing class $config_class element $element ($type $value_type)";
        $vt_obj->store($value_type);
        $obj->load("min=$min") if defined $min;
        $obj->load("max=$max") if defined $max;
    }
    elsif (not $old_vt) {
        say "Storing new class $config_class element $element ($type uniline)";
        # do not override an already defined type to enable manual corrections
        $vt_obj->store("uniline");
    }
    return $obj;
}

# If you change the mapped class names (i.e. the values of this hash),
# be sure to rename the matching class with cme meta edit
my @list = qw/exec kill resource-control service/;
my %map = (
    'exec' => 'Common::Exec',
    'kill' => 'Common::Kill',
    'resource-control' => 'Common::ResourceControl',
);

my $data = parse_xml(\@list, \%map) ;

# Itself constructor returns an object to read or write the data
# structure containing the model to be edited
my $rw_obj = Config::Model::Itself -> new () ;

# now load the existing model to be edited
$rw_obj -> read_all() ;
my $meta_root = $rw_obj->meta_root;

foreach my $config_class (keys $data->{class}->%*) {
    my $desc = $data->{class}{$config_class};
    my $steps = "class:$config_class class_description";
    say "Storing class $config_class description";
    $meta_root->grab(step => $steps, autoadd => 1)->store(join("\n\n",$desc->@*));
}

foreach my $cdata ($data->{element}->@*) {
    my ($config_class, $element, $desc) = $cdata->@*;

    my $obj = setup_element ($meta_root, $config_class, $element, $desc);

    my $old_desc = $obj->grab_value("description") // '';
    if ($old_desc ne $desc) {
        say "updating description of class $config_class element $element";
        $obj->fetch_element("description")->store($desc);
    }
}

say "Saving model";
$rw_obj->write_all;
