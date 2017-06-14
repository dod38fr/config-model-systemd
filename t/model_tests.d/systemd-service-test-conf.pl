# systemd tests for user

# list of tests. This modules looks for @tests global variable
@tests = (
    {
        name => 'basic-service',
        config_file => 'gmail-imap-tunnel@.service',
        check => [
            'service:"gmail-imap-tunnel@" Unit Description' => 'Tunnel IMAPS connections to Gmail with corkscrew',
            'service:"gmail-imap-tunnel@" Service ExecStart:0' => "-/usr/bin/socat - PROXY:127.0.0.1:imap.gmail.com:993,proxyport=8888"
        ],
        file_contents_unlike => {
            "gmail-imap-tunnel@.service" => qr/disable/ ,
        },
    },

    {
        name => 'basic-socket',
        config_file => 'gmail-imap-tunnel.socket',
        check => [
            'socket:gmail-imap-tunnel Unit Description' => "Socket for Gmail IMAP tunnel",
            'socket:gmail-imap-tunnel Install WantedBy' => 'sockets.target',
            'socket:gmail-imap-tunnel Socket ListenStream:0' => 9995,
            'socket:gmail-imap-tunnel Socket Accept' => "yes"
        ],
        file_contents_unlike => {
            "gmail-imap-tunnel.socket" => qr/disable/ ,
        }
    },

    {
        name => 'from-scratch',
        config_file => 'test.service',
        load => 'service:test Unit Description="test from scratch"',
        file_contents_like => {
            "test.service" => qr/from scratch/ ,
        },
    }
);

1; # to keep Perl happy
