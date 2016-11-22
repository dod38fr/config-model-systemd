package Config::Model::Systemd;

use 5.10.1;

use Config::Model 2.094;

1;

# ABSTRACT: Editor and validator for systemd configuration files

__END__

=pod

=head1 SYNOPSIS

=head2 command line

Requires L<App::Cme>:

 $ cme edit systemd-user
 $ cme check systemd-user

 # cme edit systemd
 # cme check systemd

=head2 Perl program

 use Config::Model qw/cme/;
 cme('systemd-user')->modify('socket:free-imap-tunnel Socket Accept=yes') ;

=head1 DESCRIPTION

This module provides a configuration editor for the configuration file
of systemd, i.e. all files in C<~/.config/systemd/user/> or all files
in C</etc/systemd/system/>

Ok. I simplified. Actually, this module provides the configuration
models of Systemd configuration file that L<cme>, L<Config::Model> and
L<Config::Model::TkUI> use to provide a configuration editor and
checker.

=head2 invoke editor

The following command loads user systemd files (from
C<~/.config/systemd/user/> and launch a graphical editor:

 cme edit systemd-user

Likewise, the following command loads system systemd configuration
files and launch a graphical editor:

 sudo cme edit systemd

=head2 Just check systemd configuration

You can also use L<cme> to run sanity checks on the configuration file:

 cme check systemd-user
 cme check systemd

=head2 Use in Perl program

As of L<Config::Model> 2.086, a L<cme/"cme(...)"> function is exported
to modify configuration in a Perl program. For instance:

 use Config::Model qw/cme/; # also import cme function
 # call cme for systemd-user, modify ans save my-imap-tunnel.socket file.
 cme('systemd-user')->modify('socket:my-imap-tunnel Socket Accept=yes') ;

Similarly, system Systemd files can be modified using C<systemd> application:

 use Config::Model qw/cme/;
 cme('systemd')->modify(...) ;

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
.

=head1 TODO

For now, only C<unit>, C<socket> and C<service> files are
supported. Please log a wishlist bug if you need other unit types to
be supported.

=head1 SUPPORT

In case of issue, please log a bug on
L<https://github.com/dod38fr/config-model-systemd/issues>.

=head1 SEE ALSO

=over

=item *

L<cme>

=item *

L<Config::Model>

=item *

L<http://github.com/dod38fr/config-model/wiki/Using-config-model>

=back

