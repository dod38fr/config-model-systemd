use strict;
use warnings;

return [
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn' => 'Unknown parameter'
      }
    ],
    'element' => [
      'Alias',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'A space-separated list of additional names this unit shall be installed under. The names listed
here must have the same suffix (i.e. type) as the unit filename. This option may be specified more than once,
in which case all listed names are used. At installation time, systemctl enable will create
symlinks from these names to the unit filename. Note that not all unit types support such alias names, and this
setting is not supported for them. Specifically, mount, slice, swap, and automount units do not support
aliasing.',
        'type' => 'list'
      },
      'WantedBy',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'This option may be used more than once, or a
space-separated list of unit names may be given. A symbolic
link is created in the C<.wants/> or
C<.requires/> directory of each of the
listed units when this unit is installed by systemctl
enable. This has the effect that a dependency of
type C<Wants> or C<Requires>
is added from the listed unit to the current unit. The primary
result is that the current unit will be started when the
listed unit is started. See the description of
C<Wants> and C<Requires> in
the [Unit] section for details.

WantedBy=foo.service in a service
C<bar.service> is mostly equivalent to
Alias=foo.service.wants/bar.service in the
same file. In case of template units, systemctl
enable must be called with an instance name, and
this instance will be added to the
C<.wants/> or
C<.requires/> list of the listed unit. E.g.
WantedBy=getty.target in a service
C<getty@.service> will result in
systemctl enable getty@tty2.service
creating a
C<getty.target.wants/getty@tty2.service>
link to C<getty@.service>.
',
        'type' => 'list'
      },
      'RequiredBy',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'This option may be used more than once, or a
space-separated list of unit names may be given. A symbolic
link is created in the C<.wants/> or
C<.requires/> directory of each of the
listed units when this unit is installed by systemctl
enable. This has the effect that a dependency of
type C<Wants> or C<Requires>
is added from the listed unit to the current unit. The primary
result is that the current unit will be started when the
listed unit is started. See the description of
C<Wants> and C<Requires> in
the [Unit] section for details.

WantedBy=foo.service in a service
C<bar.service> is mostly equivalent to
Alias=foo.service.wants/bar.service in the
same file. In case of template units, systemctl
enable must be called with an instance name, and
this instance will be added to the
C<.wants/> or
C<.requires/> list of the listed unit. E.g.
WantedBy=getty.target in a service
C<getty@.service> will result in
systemctl enable getty@tty2.service
creating a
C<getty.target.wants/getty@tty2.service>
link to C<getty@.service>.
',
        'type' => 'list'
      },
      'Also',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Additional units to install/deinstall when
this unit is installed/deinstalled. If the user requests
installation/deinstallation of a unit with this option
configured, systemctl enable and
systemctl disable will automatically
install/uninstall units listed in this option as well.

This option may be used more than once, or a
space-separated list of unit names may be
given.',
        'type' => 'list'
      },
      'DefaultInstance',
      {
        'description' => 'In template unit files, this specifies for
which instance the unit shall be enabled if the template is
enabled without any explicitly set instance. This option has
no effect in non-template unit files. The specified string
must be usable as instance identifier.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'generated_by' => 'parseman.pl from systemd doc',
    'name' => 'Systemd::Section::Install'
  }
]
;

