#!/usr/bin/perl

use strict;
use warnings;
use 5.22.0;
use utf8;

use lib 'lib';

use XML::Twig;
use Path::Tiny;
use Config::Model::Itself;
use Config::Model::Exception;
use Getopt::Long;
use experimental qw/postderef signatures/ ;

my %opt;
GetOptions (\%opt, "from=s") or die("Error in command line arguments\n");

my $systemd_path = path($opt{from});
die "Can't open directory ".$opt{from}."\n" unless $systemd_path->is_dir;

my $systemd_man_path = $systemd_path->child('man');

Config::Model::Exception::Trace(1);

sub parse_xml ($list, $map) {

    my %data = ( element => [] );
    my $config_class;
    my $file ;

    my $desc = sub ($t, $elt) {
        my $txt = $elt->text;
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
        my $url = "https://manpages.debian.org/cgi-bin/man.cgi?query=$man&sektion=$nb&manpath=Debian+unstable+sid";
        $elt->set_text( qq!L<$man($nb)|"$url">!);
    };

    my $condition_variable = sub  ($t, $elt) {
        my @var_list = $elt->children('term') ;
        my $listitem = $elt->first_child('listitem');
        my $pre_doc = $listitem->first_child_text('para');
        my $post_doc = $listitem->last_child_text('para');
        foreach my $var_elt (@var_list) {
            my $var_name = $var_elt->text;
            my ($var_doc_elt) = $listitem->get_xpath(qq!./para/varname[string()="$var_name"]!);
            #say "condition_variable $var_name found at ",$var_doc_elt->path;
            my ($name, $extra_info) = split '=', $var_name, 2;
            say $file->basename(".xml").": class $config_class element $name, trashed $extra_info" if $extra_info;
            my $desc = join ("\n\n", $pre_doc, $var_doc_elt->parent->text, $post_doc);
            push $data{element}->@*, [$config_class => $name => $desc => $extra_info];
        }
    };

    my $variable = sub  ($t, $elt) {
        return $condition_variable->($t, $elt) if $elt->first_child_text('term') =~ /^Condition/;
        my $desc = $elt->first_child('listitem')->text;
        $desc =~ s/(\w+)=/C<$1>/g;

        foreach my $term_elt ($elt->children('term')) {
            my $varname = $term_elt->first_child('varname')->text;
            my ($name, $extra_info) = split '=', $varname, 2;
            say $file->basename(".xml").": class $config_class element $name, trashed $extra_info" if $extra_info;

            push $data{element}->@*, [$config_class => $name => $desc => $extra_info];
        }
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
        $file = $systemd_man_path->child("systemd.$subsystem.xml");
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

    # trim description (which is not saved in this sub) to simplify
    # the regexp below
    $desc =~ s/[\s\n]+/ /g;

    my $value_type
        = $desc =~ /Takes an? (boolean|integer)/ ? $1
        : $desc =~ /Takes time \(in seconds\)/   ? 'integer'
        : $desc =~ /Takes one of/                ? 'enum'
        : $extra_info =~ /\w\|\w/                ? 'enum'
        :                                          'uniline';

    my ($min, $max) = ($desc =~ /Takes an integer between ([-\d]+) (?:\([\w\s]+\))? and ([-\d+])/) ;

    my @load ;

    push @load, qw/type=list cargo/ if $element =~ /^Exec/ or $desc =~ /may be specified more than once/;

    push @load, 'type=leaf', "value_type=$value_type";

    if ($extra_info =~ /\w\|\w/) {
        $extra_info =~ s/\|/,/g;
        push @load, "choice=$extra_info";
    }
    elsif ($desc =~ /Takes one of/) {
        my ($choices) = ($desc =~ /Takes one of ([^.]+?)(?:\.|to test)/);
        say "$element found ->$choices<-";
        $choices =~ s/\(the default\)//g;
        $choices =~ s/\b(or|and)\b/,/g;
        $choices =~ s/\s//g;
        $choices =~ s/C<(\w+)>/$1/g;
        $choices =~ s/,+/,/g;
        say "set choice $choices";
        push @load, qq!choice=$choices!;
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
    my $desc_ref = $data->{class}{$config_class};
    my $desc_text = join("\n\n",$desc_ref->@*);
    $desc_text =~ s/^\s+//gm;

    $desc_text.="\nThis configuration class was generated from systemd documentation.\n"
        ."by L<parse-man.pl|https://github.com/dod38fr/config-model-systemd/contrib/parse-man.pl>\n";
    my $steps = "class:$config_class class_description";
    $meta_root->grab(step => $steps, autoadd => 1)->store($desc_text);

    # TODO: indicates systemd version
    $meta_root->load( steps => [
        qq!class:$config_class generated_by="systemd parse-man.pl"!,
        qq!copyright:0="2010-2016 Lennart Poettering and others"!,
        qq!copyright:1="2016 Dominique Dumont"!,
        qq!license="LGPLv2.1+"!,
        qq!accept:".*" type=leaf value_type=uniline!,
    ]);

}

foreach my $cdata ($data->{element}->@*) {
    my ($config_class, $element, $desc, $extra_info) = $cdata->@*;

    my $obj = setup_element ($meta_root, $config_class, $element, $desc, $extra_info);

    # cleanup one utf8 characters (aka \x{2014}). This can be removed once Config::Model 2.084
    # is released: generated pod will declare utf8 encoding
    $desc =~ s/—/--/g;
    $desc =~ s/ / /g; # not exactly an underscore

    # cleanup empty lines
    $desc =~ s/^\s+//gm;

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
