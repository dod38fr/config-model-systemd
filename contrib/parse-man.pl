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

my @list = qw/exec/;
my %map = (
    'exec' => 'Common::Exec',
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

my %data = ( class => [], element =>[] );

sub desc ($t, $elt) {
    my $txt = $elt->trimmed_text;
    # there's black magic in XML::Twig that trash error message
    # contained in an error object.  So the error must be stringified
    # explicitly before being sent upward

    # but it's easier to store data and handle it later outside of XML::Twig realm
    push $data{class}->@* , [ $config_class => $txt ];
}

sub manpage ($t, $elt) {
    my $man = $elt->first_child('refentrytitle')->text;
    my $nb = $elt->first_child('manvolnum')->text;
    $elt->set_text( "L<$man($nb)>");
}

sub variable  ($t, $elt) {
    my $name = $elt->first_child('term')->first_child('varname')->text;
    $name =~ s/=$//;
    my $desc = $elt->first_child('listitem')->trimmed_text;
    $desc =~ s/(\w+)=/C<$1>/g;

    say "Storing class $config_class parameter $name";
    push $data{element}->@*, [$config_class => $name => $desc ];
}

foreach my $subsystem (@list) {
    my $file = $systemd_path->child("systemd.$subsystem.xml");
    $config_class = 'Systemd::'.( $map{$subsystem} || ucfirst($subsystem));
    $twig->parsefile($file);
}

say "Storing class descriptions";
foreach my $cdata ($data{class}->@*) {
    my ($config_class, $desc) = $cdata->@*;
    my $steps = "class:$config_class class_description";
    $meta_root->grab(step => $steps, autoadd => 1)->store($desc);
}

say "Storing class elements";
foreach my $cdata ($data{element}->@*) {
    my ($config_class, $element, $desc) = $cdata->@*;
    my $steps_2_element = "class:$config_class element:$element";

    $meta_root->grab(step => "$steps_2_element description", autoadd => 1)->store($desc);
}

say "Saving model";
$rw_obj->write_all;
