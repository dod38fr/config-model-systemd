# systemd tests for user

# can be removed once Config::model::tester 3.002 is out
$model_to_test = "Systemd::Socket";

# list of tests. This modules looks for @tests global variable
@tests = (
    {
        name => 'basic-socket',
        config_file => 'gmail-imap-tunnel.socket',
        check => [
            'Unit Description' => "Socket for Gmail IMAP tunnel",
            'Install WantedBy:0' => 'sockets.target',
            'Socket ListenStream:0' => 9995,
            'Socket Accept' => "yes"
        ],
        file_contents_unlike => {
            "gmail-imap-tunnel.socket" => qr/disable/ ,
        }
    },
);

1; # to keep Perl happy
