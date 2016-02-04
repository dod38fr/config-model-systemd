#!/usr/bin/perl

use strict;
use warnings;
use 5.22.0;

use XML::Twig;
use XXX;
use Path::Tiny;
use Config::Model::Itself;
use experimental qw/postderef signatures/ ;

my $systemd_path = path('/home/domi/debian-dev/systemd-228/man/');

# If you change the mapped class names (i.e. the values of this hash),
# be sure to rename the matching class with cme meta edit
my @list = qw/exec kill resource-control service/;
my %map = (
    'exec' => 'Common::Exec',
    'kill' => 'Common::Kill',
    'resource-control' => 'Common::ResourceControl',
);


my $twig = XML::Twig->new ( 
    twig_handlers => {
        'refsect1[string(title)=~ /Description/]/para' => \&desc,
        'citerefentry' => \&manpage,
        'literal' => sub { my $t = $_->text(); $_->set_text("C<$t>");},
        'refsect1[string(title)=~ /Options/]/variablelist/varlistentry' => \&variable,
    }
);

# Itself constructor returns an object to read or write the data
# structure containing the model to be edited
my $rw_obj = Config::Model::Itself -> new () ;

# now load the existing model to be edited
$rw_obj -> read_all() ;
my $meta_root = $rw_obj->meta_root;
my $config_class;

my %data = ( element => [] );

sub desc ($t, $elt) {
    my $txt = $elt->trimmed_text;
    # there's black magic in XML::Twig that trash error message
    # contained in an error object.  So the error must be stringified
    # explicitly before being sent upward

    # but it's easier to store data and handle it later outside of XML::Twig realm
    $data{class}{$config_class} //= [];
    push $data{class}{$config_class}->@*, $txt;
}

sub manpage ($t, $elt) {
    my $man = $elt->first_child('refentrytitle')->text;
    my $nb = $elt->first_child('manvolnum')->text;
    $elt->set_text( "L<$man($nb)>");
}

sub variable  ($t, $elt) {
    my $varname = $elt->first_child('term')->first_child('varname')->text;
    my ($name, $trash) = split '=', $varname, 2;
    say "class $config_class element $name, trashed $trash" if $trash;
    my $desc = $elt->first_child('listitem')->trimmed_text;
    $desc =~ s/(\w+)=/C<$1>/g;

    push $data{element}->@*, [$config_class => $name => $desc ];
}

foreach my $subsystem (@list) {
    my $file = $systemd_path->child("systemd.$subsystem.xml");
    $config_class = 'Systemd::'.( $map{$subsystem} || 'Section::'.ucfirst($subsystem));
    $twig->parsefile($file);
}

foreach my $config_class (keys $data{class}->%*) {
    my $desc = $data{class}{$config_class};
    my $steps = "class:$config_class class_description";
    say "Storing class $config_class description";
    $meta_root->grab(step => $steps, autoadd => 1)->store(join("\n\n",$desc->@*));
}

foreach my $cdata ($data{element}->@*) {
    my ($config_class, $element, $desc) = $cdata->@*;
    my $steps_2_element = "class:$config_class element:$element";

    my $value_type ;
    my $obj = $meta_root->grab(step => "$steps_2_element", autoadd => 1);
    if ($desc =~ /Takes an? (boolean|integer)/) {
        $value_type = $1;
    }
    elsif ($desc =~ /Takes time \(in seconds\)/) {
        $value_type = 'integer';
    }

    $obj->load("type=leaf"); # make sure that value_type is accessible

    my $vt_obj = $obj->fetch_element("value_type");
    my $old_vt = $vt_obj->fetch(check => 'no') // '';
    if ($value_type and $value_type ne $old_vt) {
        # force type
        say "Storing class $config_class element $element ($value_type)";
        $vt_obj->store($value_type);
    }
    elsif (not $old_vt) {
        say "Storing new class $config_class element $element (uniline)";
        # do not override an already defined type to enable manual corrections
        $vt_obj->store("uniline");
    }


    my $old_desc = $obj->grab_value("description") // '';
    if ($old_desc ne $desc) {
        say "updating description of class $config_class element $element";
        $obj->fetch_element("description")->store($desc);
    }
}

say "Saving model";
$rw_obj->write_all;
