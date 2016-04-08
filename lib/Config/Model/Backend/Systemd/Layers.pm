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
        # paths documented by systemd-system.conf man page
        @layers = qw!
                        /etc/systemd/system.conf.d/
                        /run/systemd/system.conf.d/
                        /lib/systemd/system.conf.d/
                    !;
    }

    return @layers;
}

1;
