package Config::Model::Backend::Systemd::Unit ;

use strict;
use warnings;
use 5.010;
use Mouse ;
use Log::Log4perl qw(get_logger :levels);
use Path::Tiny;

extends 'Config::Model::Backend::IniFile';

with 'Config::Model::Backend::Systemd::Layers';

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

    if ($self->node->instance->layered) {
        # avoid deep recursion in layered mode
        return $self->SUPER::read(@_);
    };

    my $dir = path($args{root}.$args{config_dir});
    die "Unknown directory $dir" unless $dir->is_dir;

    my $unit_type = $self->node->element_name;
    my $unit_name   = $self->node->index_value;

    $self->node->instance->layered_start;
    # load layers for this service
    foreach my $layer ($self->default_directories) {
        my $dir = path ($args{root}.$layer);
        next unless $dir->is_dir;

        my $file = $dir->child($unit_name.'.'.$unit_type);
        next unless $file->exists;

        say "reading default layer from unit $unit_type name $unit_name from $file";
        my $fh = new IO::File;
        $fh->open($file);
        $fh->binmode(":utf8");

        my $res = $self->read(
            io_handle => $fh,
            check => $args{check},
        );
        $fh->close;
        die "failed $file read " unless $res;
    }
    $self->node->instance->layered_stop;

    if (path($args{file_path})->realpath eq '/dev/null') {
        say "skipping  unit $unit_type name $unit_name from ".$args{config_dir};
    }
    else {
        say "reading unit $unit_type name $unit_name from ".$args{config_dir};

        # mouse super() does not work...
        $self->SUPER::read(@_);
    }
}

# overrides call to node->load_data
sub load_data {
    my $self = shift;
    my %args = @_ ; # data, check, split_reg

    my $data = $args{data} ;
    # use ObjTreeScanner ?
    my $disp_leaf = sub {
        my ($scanner, $data, $node,$element_name,$index, $leaf_object) = @_ ;
        $leaf_object->store($data);
    } ;

    my $unit_cb = sub {
        my ($scanner, $data_ref,$node,@elements) = @_ ;

        # read data in the model order
        foreach my $elt (@elements) {
            my $unit_data = $data_ref->{$elt}; # extract relevant data
            next unless defined $unit_data;
            $scanner->scan_element($unit_data, $node,$elt) ;
        }
    };

    # this setup is required because IniFile backend cannot push value
    # coming from several ini files on a single list element. (even
    # though keys can be repeated in a single ini file and stored as
    # list in a single config element, this is not possible if the
    # list values come from several files)
    my $list_cb = sub {
        my ($scanner, $data,$node,$element_name,@idx) = @_ ;
        my $list_ref = ref($data) ? $data : [ $data ];
        my $list_obj= $node->fetch_element($element_name);
        foreach my $d (@$list_ref) {
            #if (length $d) {
            $list_obj->push($d); # push also empty values
            #}
            #else {
            #    $list_obj->clear;
            #}
        }

    };

    my $scan = Config::Model::ObjTreeScanner-> new (
        node_content_cb => $unit_cb,
        list_element_cb => $list_cb,
        leaf_cb => $disp_leaf,
    ) ;

    $scan->scan_node($data, $self->node) ;
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

    if ($self->node->grab_value('disable')) {
        my $fp = path($args{file_path});
        if ($fp->realpath ne '/dev/null') {
            say "symlinking file $fp to /dev/null";
            $fp->remove;
            symlink ('/dev/null', $fp->stringify);
        }
    }
    else {
        # mouse super() does not work...
        $self->SUPER::write(@_);
    }
}

no Mouse ;
__PACKAGE__->meta->make_immutable ;
