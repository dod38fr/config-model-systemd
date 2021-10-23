# systemd tests for user
use strict;
use warnings;

# list of tests.
my @tests = (
    {
        name => 'basic-service',
        config_file => 'gmail-imap-tunnel@.service',
        check => [
            'Unit Description' => 'Tunnel IMAPS connections to Gmail with corkscrew',
            'Service ExecStart:0' => "-/usr/bin/socat - PROXY:127.0.0.1:imap.gmail.com:993,proxyport=8888"
        ],
        file_contents_unlike => {
            "gmail-imap-tunnel@.service" => qr/disable/ ,
        },
    },

    {
        name => 'from-scratch',
        config_file => 'test.service',
        load => 'Unit Description="test from scratch"',
        file_contents_like => {
            "test.service" => qr/from scratch/ ,
        },
    }
);

return { tests => \@tests } ;
