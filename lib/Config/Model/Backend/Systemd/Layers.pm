package Config::Model::Backend::Systemd::Layers;

use Mouse::Role;


sub default_directories {
    my $self = shift ;
    my $app = $self->node->instance->application;

    my @layers ;
    if ($app eq 'systemd-user') {
        @layers = (
            # paths documented by systemd-system.conf man page
            '/etc/systemd/user.conf.d/',
            '/run/systemd/user.conf.d/',
            '/usr/lib/systemd/user.conf.d/',
            # path found on Debian
            '/usr/lib/systemd/user/'
        );
    }
    elsif ($app eq 'systemd') {
        @layers = (
            # paths documented by systemd-system.conf man page
            '/etc/systemd/system.conf.d/',
            '/run/systemd/system.conf.d/',
            '/lib/systemd/system.conf.d/',
            # not documented but used to symlink to real files
            '/etc/systemd/system/',
            # path found on Debian
            '/lib/systemd/system/',
        );
    }

    return @layers;
}

1;

# ABSTRACT: Role that provides Systemd default directories

__END__

=pod

=head1 SYNOPSIS

 package Config::Model::Backend::Systemd ;
 extends 'Config::Model::Backend::Any';
 with 'Config::Model::Backend::Systemd::Layers';

=head1 DESCRIPTION

Small role to provide Systemd default directories (user or system) to
L<Config::Model::Backend::Systemd> and L<Config::Model::Backend::Systemd::Unit>.

=head1 Methods

=head2 default_directories

Returns a list of default directory, depending on the application used (either
C<systemd> or C<systemd-user>.

=cut

