package Config::Model::Backend::Systemd ;

use strict;
use warnings;
use 5.010;
use Mouse ;
use Log::Log4perl qw(get_logger :levels);
use Path::Tiny 0.086;

extends 'Config::Model::Backend::Any';
with 'Config::Model::Backend::Systemd::Layers';

my $logger = get_logger("Backend::Systemd");

has config_dir => (
    is => 'rw',
    isa => 'Path::Tiny'
);

# TODO: accepts other systemd suffixes
my $filter = qr/\.(service|socket)$/;

sub read {
    my $self = shift ;
    my %args = @_ ;

    # args are:
    # root       => './my_test',  # fake root directory, used for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # io_handle  => $io           # IO::File object
    # check      => yes|no|skip


    my $dir = path($args{root}.$args{config_dir});
    die "Unknown directory $dir" unless $dir->is_dir;

    # load layers
    foreach my $layer ($self->default_directories) {
        my $dir = path ($args{root}.$layer);
        next unless $dir->is_dir;

        $self->config_dir($dir);
        foreach my $file ($dir->children($filter) ) {
            my $unit_name = $file->basename($filter);
            my ($unit_type) = ($file =~ $filter);
            $logger->debug( "registering unit $unit_type name $unit_name from $file (layered mode))");
            # force config_dir during init
            $self->node->load(step => "$unit_type:$unit_name", check => $args{check} ) ;
        }
    }

    $self->config_dir($dir);
    foreach my $file ($dir->children($filter) ) {
        my ($unit_type) = ($file =~ $filter);
        my $unit_name = $file->basename($filter);
        if ($file->realpath eq '/dev/null') {
            $logger->debug("unit $unit_type name $unit_name from $file is disabled");
            $self->node->load(step => "$unit_type:$unit_name disable=1", check => $args{check} ) ;
        }
        else {
            $logger->debug("registering unit $unit_type name $unit_name from $file");
            $self->node->load(step => "$unit_type:$unit_name", check => $args{check} ) ;
        }
    }
    return 1 ;
}

sub write {
    my $self = shift ;
    my %args = @_ ;

    # args are:
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # io_handle  => $io           # IO::File object
    # check      => yes|no|skip

    my $dir = path($args{root}.$args{config_dir});
    die "Unknown directory $dir" unless $dir->is_dir;

    # delete files for non-existing elements (deleted services)
    foreach my $file ($dir->children($filter) ) {
        my ($unit_type) = ($file =~ $filter);
        my $unit_name = $file->basename($filter);

        my $unit_collection = $self->node->fetch_element($unit_type);
        if (not $unit_collection->defined($unit_name)) {
            $logger->warn("removing file $file of deleted service");
            $file->remove;
        }
    }

    return 1;
}

no Mouse ;
__PACKAGE__->meta->make_immutable ;
