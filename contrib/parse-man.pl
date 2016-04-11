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

sub parse_xml ($list, $map) {

    my %data = ( element => [] );
    my $config_class;
    my $file ;

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
        my ($name, $extra_info) = split '=', $varname, 2;
        say $file->basename(".xml").": class $config_class element $name, trashed $extra_info" if $extra_info;
        my $desc = $elt->first_child('listitem')->trimmed_text;
        $desc =~ s/(\w+)=/C<$1>/g;

        push $data{element}->@*, [$config_class => $name => $desc => $extra_info];
    };

    my $set_config_class = sub ($name) {
        $config_class = 'Systemd::'.( $map->{$name} || 'Section::'.ucfirst($name));
        say  $file->basename(".xml").": Parsing class $config_class";
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
        $file = $systemd_path->child("systemd.$subsystem.xml");
        $set_config_class->($subsystem);
        $twig->parsefile($file);
    }

    return \%data;
}


sub setup_element ($meta_root, $config_class, $element, $desc, $extra_info) {

    my $obj = $meta_root->grab(
        step => "class:$config_class element:$element",
        autoadd => 1
    );

    my $value_type
        = $desc =~ /Takes an? (boolean|integer)/ ? $1
        : $desc =~ /Takes time \(in seconds\)/   ? 'integer'
        : $extra_info =~ /\w\|\w/                ? 'enum'
        :                                          'uniline';

    my ($min, $max) = ($desc =~ /Takes an integer between ([-\d]+) (?:\([\w\s]+\))? and ([-\d+])/) ;

    my @load ;

    push @load, qw/type=list cargo/ if $element =~ /^Exec/ or $desc =~ /may be specified more than once/;

    push @load, 'type=leaf', "value_type=$value_type";

    if ($value_type eq 'enum') {
        $extra_info =~ s/\|/,/g;
        push @load, "choice=$extra_info";
    }

    push @load, "min=$min" if defined $min;
    push @load, "max=$max" if defined $max;

    $obj->load(step => \@load);

    return $obj;
}

# If you change the mapped class names (i.e. the values of this hash),
# be sure to rename the matching class with cme meta edit
my @list = qw/exec kill resource-control service unit socket/;
# default class name is Systemd::Section::ucfirst($item)
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

# remove old generated classes
foreach my $config_class ($meta_root->fetch_element('class')->fetch_all_indexes) {
    my $gen = $meta_root->grab_value(
        step => qq!class:$config_class generated_by!,
        mode => 'loose',
    );
    next unless $gen and $gen =~ /parse-man/;
    $meta_root->load(qq!class:-$config_class!);
}


say "Creating systemd model...";

foreach my $config_class (keys $data->{class}->%*) {
    my $desc = $data->{class}{$config_class};
    my $steps = "class:$config_class class_description";
    $meta_root->grab(step => $steps, autoadd => 1)->store(join("\n\n",$desc->@*));

    # TODO: indicates systemd version
    $meta_root->load( steps => [
        qq!class:$config_class generated_by="systemd parse-man.pl"!,
        qq!accept:".*" type=leaf value_type=uniline!,
    ]);

}

foreach my $cdata ($data->{element}->@*) {
    my ($config_class, $element, $desc, $extra_info) = $cdata->@*;

    my $obj = setup_element ($meta_root, $config_class, $element, $desc, $extra_info);

    $obj->fetch_element("description")->store($desc);
}

say "Tweaking systemd model...";

$meta_root->load( << "EOL"
! class:Systemd::Section::Service
      include:=Systemd::Common::ResourceControl,Systemd::Common::Exec,Systemd::Common::Kill

EOL
);

say "Saving systemd model...";
$rw_obj->write_all;

say "Done.";
