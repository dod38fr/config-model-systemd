#!/usr/bin/perl

use strict;
use warnings;
use 5.10.0;

use XML::Twig;
use XXX;
use Path::Tiny;
use Config::Model::Itself;

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
my $meta_root = $rw_obj->config_root;
my $config_class;

sub desc {
    my( $t, $elt)= @_;
    my $txt = $elt->trimmed_text;
    say "before";
    eval {
        $meta_root->grab(step =>"class:$config_class class_dwescription", autoadd => 1)->store($txt);
    };
    say $@;
    my $err = $@;
    die "foo".$err;
    say "after";
}

sub manpage {
    my( $t, $elt)= @_;
    my $man = $elt->first_child('refentrytitle')->text;
    my $nb = $elt->first_child('manvolnum')->text;
    $elt->set_text( "L<$man($nb)>");
}

sub variable {
    my( $t, $elt)= @_;
    my $name = $elt->first_child('term')->first_child('varname')->text;
    $name =~ s/=$//;
    my $desc = $elt->first_child('listitem')->trimmed_text;
    $desc =~ s/(\w+)=/C<$1>/g;

    say "Storing $config_class $name";

    #$meta_root->grab("class:$config_class element:$name description")->store($desc);
}

foreach my $subsystem (@list) {
    my $file = $systemd_path->child("systemd.$subsystem.xml");
    $config_class = 'Systemd::'.( $map{$subsystem} || ucfirst($subsystem));
    $twig->parsefile($file);
}

