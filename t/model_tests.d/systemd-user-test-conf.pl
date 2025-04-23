# systemd tests for user
use strict;
use warnings;

# list of tests.
my @tests = (
    {
        name => 'basic-service',
        backend_arg => 'gmail',
        file_contents_unlike => {
            "home/joe/.config/systemd/user/gmail-imap-tunnel@.service" 
            => qr/disable/ ,
        },
    },

    {
        name => 'basic-socket',
        backend_arg => 'gmail',
        file_contents_unlike => {
            "home/joe/.config/systemd/user/gmail-imap-tunnel.socket" 
            => qr/disable/ ,
        }
    },

    {
        name => 'override-service',
        backend_arg => 'obex',
        setup => {
            'main-obex' => '/usr/lib/systemd/user/obex.service',
        },
        load => 'service:obex Service Environment:0="TEST=true"',
        file_contents_like => {
            "home/joe/.config/systemd/user/obex.service.d/override.conf" => qr/TEST=true/ ,
        },
        file_check_sub => sub {
            my $list_ref = shift ;
            # file added during tests
            push @$list_ref, "/home/joe/.config/systemd/user/obex.service.d/override.conf" ;
        }
    },
    {
        name => 'overridden-service',
        backend_arg => 'obex',
        data_from => 'override-service',
        setup => {
            'main-obex' => '/usr/lib/systemd/user/obex.service',
            'user-obex' => '~/.config/systemd/user/obex.service.d/override.conf',
        },
        check => [
            'service:obex Unit Description' => 'Le service Obex a la dent bleue',
            'service:obex Unit Description' => {
                mode => 'user',
                value => 'Le service Obex a la dent bleue'
            },
            'service:obex Unit Description' => {
                mode => 'layered',
                value => 'Bluetooth OBEX service'
            },
        ]
    },
    {
        name => 'delete-service',
        backend_arg => 'obex.service',
        setup => {
            'main-obex' => '/usr/lib/systemd/user/obex.service',
            'user-obex' => '~/.config/systemd/user/obex.service.d/override.conf',
        },
        load => 'service:obex Unit Description~',
        check => [
            'service:obex Unit Description' => {
                mode => 'user',
                value => 'Bluetooth OBEX service'
            },
        ],
        file_check_sub => sub {
            my $list_ref = shift ;
            # file added during tests
            @$list_ref = grep { /usr/ } @$list_ref ;
        }
    },

    {
        name => 'from-scratch',
        backend_arg => 'test.service',
        load => 'service:test Unit Description="test from scratch"',
        file_contents_like => {
            "home/joe/.config/systemd/user/test.service" => qr/from scratch/ ,
        },
    },
    {
        name => 'duplicity',
        backend_arg => 'duplicity',
        check => [
            'service:duplicity Service ExecStart:0' => "my-backup",
            'timer:duplicity Timer OnCalendar:0' => '13:00',
            'timer:duplicity Unit Description'=>"Run duplicity",
        ]
    }
);

return {
    tests => \@tests,
    home_for_test=>'/home/joe',
    conf_dir => '~/.config/systemd/user/',
    config_file_name => 'systemd-user',
}

