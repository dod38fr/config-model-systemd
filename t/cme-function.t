# -*- cperl -*-
use strict;
use warnings;
use Path::Tiny;

use Test::More;
use Config::Model qw/cme/;
use Log::Log4perl qw(:easy :levels);

my $arg = shift || '';
my ( $log, $show ) = (0) x 2;

my $trace = $arg =~ /t/ ? 1 : 0;
$log  = 1 if $arg =~ /l/;
$show = 1 if $arg =~ /s/;

my $home = $ENV{HOME} || "";
my $log4perl_user_conf_file = "$home/.log4config-model";

if ( $log and -e $log4perl_user_conf_file ) {
    Log::Log4perl::init($log4perl_user_conf_file);
}
else {
    Log::Log4perl->easy_init( $log ? $WARN : $ERROR );
}

Config::Model::Exception::Any->Trace(1) if $arg =~ /e/;

# pseudo root where config files are written by config-model
my $wr_root = path('wr_root');

# cleanup before tests
$wr_root->remove_tree;
$wr_root->mkpath;

{
    my $instance = cme(
        application => 'systemd-file',
        backend_arg => 'test.service',
        root_dir => $wr_root->child('from-scratch')->stringify
    );


    $instance->modify('service:test Unit Description="test single unit"');
    # test minimal modif (re-order)
    $instance->save(force => 1);
    ok(1,"data saved");
}


done_testing;

