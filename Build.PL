
use Module::Build;

use warnings;
use strict;

require 5.010001 ;

my @version_info = @ARGV ? ( dist_version => $ARGV[0] ) : ();

my %appli_files = map { ( $_, $_ ) } glob("lib/Config/Model/*.d/*");

my $build = Module::Build->new(
    module_name => 'Config::Model::Systemd',
    @version_info,
    license       => 'lgpl',
    appli_files   => \%appli_files,
    dist_abstract => 'configuration editor for systemd',
    dist_author   => 'Dominique Dumont (ddumont at cpan dot org)',

##{ $plugin->get_prereqs ##}

    add_to_cleanup => [ qw/wr_root/ ],
);

$build->add_build_element('pl');
$build->add_build_element('appli');

$build->create_build_script;
