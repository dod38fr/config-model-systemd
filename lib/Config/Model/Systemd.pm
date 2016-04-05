package Config::Model::Systemd;

use 5.10.1;

use Config::Model 2.043;

1;

# ABSTRACT: Edit and validate Systemd configuration files

__END__

=pod

=head1 SYNOPSIS

=head2 invoke editor

The following command will load user systemd files (from
C<~/.config/systemd/user/> and launch a graphical editor:

 cme edit systemd-user

=head2 Just check systemd configuration

You can also use L<cme> to run sanity checks on the configuration file:

 cme check systemd-user

=head2 Fix warnings

When run, cme may issue several warnings regarding the content of your file. 
You can choose to  fix (most of) these warnings with the command:

 cme fix systemd-user

=head1

This module provides a configuration editor (and models) for the 
configuration file of Systemd, i.e. all files in C<~/.config/systemd/user/>

This module can also be used to modify safely the content of this file
from a Perl programs.

=head1 SEE ALSO

=over

=item *

L<cme>

=item *

L<Config::Model>

=item *

http://github.com/dod38fr/config-model/wiki/Using-config-model

=back

