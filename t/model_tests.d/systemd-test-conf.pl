# systemd tests (system files)

$conf_dir = '/etc/systemd/system/';

# list of tests. This modules looks for @tests global variable
@tests = (
    {
        name => 'sshd-service',
        setup => {
            'main-sshd' => $conf_dir.'sshd.service',
        }
    },

    {
        name => 'disable-service',
        setup => {
            'main-sshd' => $conf_dir.'sshd.service',
        },
        load => "service:sshd disable=1",
        wr_check => { 'service:sshd disable' => 1 },
    },
);

1; # to keep Perl happy
