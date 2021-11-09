package Config::Model::Systemd;

use strict;
use warnings;

use 5.10.1;

use Config::Model 2.143;

1;

# ABSTRACT: Editor and validator for systemd configuration files

__END__

=pod

=encoding utf-8

=head1 SYNOPSIS

 # run on one service:
 $ sudo cme <cmd> systemd-service <name>  # run command on name.service
 $ sudo cme <cmd> systemd-socket <name>   # run command on name.socket
 $ sudo cme <cmd> systemd-timer <name>    # run command on name.timer

 # run on several user units:
 # Run on several units:
 $ sudo cme <cmd> systemd *         # run command on all units
 $ sudo cme <cmd> systemd <pattern> # run command on all units matching pattern
 $ sudo cme <cmd> systemd <pattern> # run command on all units matching pattern

 $ cme <cmd> systemd-user <pattern> # run command on all user units matching pattern

 # run on one service file (for unit development):
 $ sudo cme <cmd> systemd-service-file <file-name>
 $ sudo cme <cmd> systemd-socket-file <file-name>
 $ sudo cme <cmd> systemd-timer-file <file-name>

=head1 Command line example

The examples below require L<App::Cme>

Dump override content of a specific service:

 $ cme dump systemd-service transmission-daemon
 Reading unit 'service' 'transmission-daemon' from '/lib/systemd/system/transmission-daemon.service'.
 ---
 Unit:
   After:
     - network-online.target
     - remote-fs.target
   Before:
     - umount.target
   Conflicts:
     - umount.target

Dump the whole service (like C<systemctl cat>):

 $ cme dump systemd-service transmission-daemon --dumptype full
 Reading unit 'service' 'transmission-daemon' from '/lib/systemd/system/transmission-daemon.service'.
 ---
 Install:
   WantedBy:
     - multi-user.target
 Service:
   CPUShares: 1024
   CPUWeight: 100
   ExecReload:
     - /bin/kill -s HUP $MAINPID
   ExecStart:
     - /usr/bin/transmission-daemon -f --log-error
 [etc...]

Edit the service override with a GUI:

 $ cme edit systemd-service transmission-daemon.service

Edit the service override with a Shell UI:

 $ cme shell systemd-service transmission-daemon.service
  >:$ ls
 Service Unit Install
  >:$ cd Unit
  >: Unit $ ll -nz
 name      │ type │ value
 ──────────┼──────┼───────────────────────────────────────
 Conflicts │ list │ umount.target
 Before    │ list │ umount.target
 After     │ list │ network-online.target,remote-fs.target
  >: Unit $ set After:.push(foo.target)
  >: Unit $ ll -nz
 name      │ type │ value
 ──────────┼──────┼──────────────────────────────────────────────────
 Conflicts │ list │ umount.target
 Before    │ list │ umount.target
 After     │ list │ network-online.target,remote-fs.target,foo.target

Run command all user units:

 $ cme edit systemd-user '*'
 $ cme check systemd-user '*'

Run command all user units that match 'foo':

 $ cme edit systemd-user foo
 $ cme check systemd-user foo

Check all root units (can be quite long on small systems):

 # cme check systemd '*'

Check all root units that match 'foo':

 # cme check systemd foo

Edit override file of C<foo.service>:

 # cme edit systemd foo.service

Run command on a service file:

 $ cme check systemd-service path/to/file.service
 $ cme edit systemd-service path/to/file.service

Timer and socket units are also supported:

 $ cme check systemd-socket path/to/file.socket
 $ cme check systemd-timer path/to/file.timer


=head2 Perl program (experimental)

 use Config::Model qw/cme/;
 cme(application => 'systemd-user' backend_arg => 'free-imap-tunnel')
    ->modify('socket:free-imap-tunnel Socket Accept=yes') ;

 cme(application => 'systemd-service', config_file => 'foo.service')
    ->modify('Unit Description="a service that does foo things"')

=head1 DESCRIPTION

This module provides (with L<cme>) a configuration editor for the
configuration files of systemd, i.e. all files in
C<~/.config/systemd/user/> or all files in C</etc/systemd/system/>

Ok. I simplified. In more details, this module provides the configuration
models of Systemd configuration file that L<cme>, L<Config::Model> and
L<Config::Model::TkUI> use to provide a configuration editor (C<cme edit>) and
checker (C<cme check>).

=head2 invoke editor

The following command loads user systemd files (from
C<~/.config/systemd/user/> and launch a graphical editor:

 cme edit systemd-user foo

Likewise, the following command loads system systemd configuration
files and launch a graphical editor to updated an override file (like
C<systemctl edit> command):

 sudo cme edit systemd foo

A developer can also edit a systemd file shipped with a software:

 cme edit systemd-service-file software-thing.service

=head2 Just check systemd configuration

You can also use L<cme> to run sanity checks on systemd configuration files:

 cme check systemd-user '*'
 cme check systemd '*' # may take time
 cme check systemd-service foo
 cme check systemd-service-file software-thing.service

=head2 Use in Perl program (experimental)

As of L<Config::Model> 2.086, a L<cme/"cme(...)"> function is exported
to modify configuration in a Perl program. For instance:

 use Config::Model qw/cme/; # also import cme function
 # call cme for systemd-user, modify ans save my-imap-tunnel.socket file.
 cme(
   application => 'systemd-user',
   backend_arg => 'my-imap-tunnel'
 )->modify('socket:my-imap-tunnel Socket Accept=yes') ;

Similarly, system Systemd files can be modified using C<systemd> application:

 use Config::Model qw/cme/;
 cme(
   application => 'systemd',
   backend_arg => 'foo'
 )->modify(...) ;

For more details and parameters, please see
L<cme|Config::Model/"cme ( ... )">,
L<modify|Config::Model::Instance/"modify ( ... )">,
L<load|Config::Model::Instance/"load ( ... )"> and
L<save|Config::Model::Instance/"save ( ... )"> documentation.

=begin :comment

=head2 Fix warnings

When run, cme may issue several warnings regarding the content of your file.
You can choose to  fix (most of) these warnings with the command:

 cme fix systemd-user

=end :comment

=head1 BUGS

The list of supported parameters is extracted from the xml documentation provided
by systemd project. This list is expected to be rather complete.

The properties of these parameters are inferred from the description
of the parameters and are probably less accurate. In case of errors,
please L<log a bug|https://github.com/dod38fr/config-model-systemd/issues>.

=head1 TODO

For now, only C<unit>, C<socket> and C<service> files are
supported. Please log a wishlist bug if you need other unit types to
be supported.

=head1 SUPPORT

In case of issue, please log a bug on
L<https://github.com/dod38fr/config-model-systemd/issues>.

=head1 Contributors

 Mohammad S Anwar

Thanks for your contributions

=head1 SEE ALSO

=over

=item *

L<cme>

=item *

L<Config::Model>

=item *

L<http://github.com/dod38fr/config-model/wiki/Using-config-model>

=back

