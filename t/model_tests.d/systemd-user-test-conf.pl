# systemd tests for user

$home_for_test='/home/joe';
$conf_dir = $home_for_test.'/.config/systemd/user/';

# list of tests. This modules looks for @tests global variable
@tests = (
    {
        # test name
        name => 'basic-service',
        # add optional specification here for t0 test
    },
);

1; # to keep Perl happy
