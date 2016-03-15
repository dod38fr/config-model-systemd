package Config::Model::Backend::Systemd ;

use strict;
use warnings;
use 5.010;
use Mouse ;
use Log::Log4perl qw(get_logger :levels);
use Path::Tiny;

extends 'Config::Model::Backend::Any';

has config_dir => (
    is => 'rw',
    isa => 'Path::Tiny'
);

sub config_file_override {
    my $self = shift ;
    my $basename = $self->node->index_value.'.'.$self->node->element_name;
    return $self->config_dir->child($basename);
}

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

    $self->config_dir($dir);
    # TODO: accepts other systemd suffixes
    my $filter = qr/\.(service|socket)$/;

    foreach my $file ($dir->children($filter) ) {
        my ($unit_type) = ($file =~ $filter);
        my $unit_name = $file->basename($filter);
        say "reading unit $unit_type name $unit_name from $file";
        $self->node->load(step => "$unit_type:$unit_name", check => $args{check} ) ;
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

    # TODO: delete files for non-existing elements (deleted services)

    return 1;
}

no Mouse ;
__PACKAGE__->meta->make_immutable ;
