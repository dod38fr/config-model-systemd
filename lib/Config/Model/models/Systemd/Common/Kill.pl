[
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'class_description' => 'Unit configuration files for services, sockets, mount
points, swap devices and scopes share a subset of configuration
options which define the killing procedure of processes belonging
to the unit.
This man page lists the configuration options shared by
these five unit types. See
L<systemd.unit(5)|"https://manpages.debian.org/cgi-bin/man.cgi?query=systemd.unit&sektion=5&manpath=Debian+unstable+sid">
for the common options shared by all unit configuration files, and
L<systemd.service(5)|"https://manpages.debian.org/cgi-bin/man.cgi?query=systemd.service&sektion=5&manpath=Debian+unstable+sid">,
L<systemd.socket(5)|"https://manpages.debian.org/cgi-bin/man.cgi?query=systemd.socket&sektion=5&manpath=Debian+unstable+sid">,
L<systemd.swap(5)|"https://manpages.debian.org/cgi-bin/man.cgi?query=systemd.swap&sektion=5&manpath=Debian+unstable+sid">,
L<systemd.mount(5)|"https://manpages.debian.org/cgi-bin/man.cgi?query=systemd.mount&sektion=5&manpath=Debian+unstable+sid">
and
L<systemd.scope(5)|"https://manpages.debian.org/cgi-bin/man.cgi?query=systemd.scope&sektion=5&manpath=Debian+unstable+sid">
for more information on the configuration file options specific to
each unit type.
The kill procedure configuration options are configured in
the [Service], [Socket], [Mount] or [Swap] section, depending on
the unit type.
This configuration class was generated from systemd documentation.
by L<parse-man.pl|https://github.com/dod38fr/config-model-systemd/contrib/parse-man.pl>
',
    'copyright' => [
      '2010-2016 Lennart Poettering and others',
      '2016 Dominique Dumont'
    ],
    'element' => [
      'KillMode',
      {
        'description' => 'Specifies how processes of this unit shall be
killed. One of
control-group,
process,
mixed,
none.If set to control-group, all remaining
processes in the control group of this unit will be killed on
unit stop (for services: after the stop command is executed,
as configured with C<ExecStop>). If set to
process, only the main process itself is
killed. If set to mixed, the
SIGTERM signal (see below) is sent to the
main process while the subsequent SIGKILL
signal (see below) is sent to all remaining processes of the
unit\'s control group. If set to none, no
process is killed. In this case, only the stop command will be
executed on unit stop, but no process be killed otherwise.
Processes remaining alive after stop are left in their control
group and the control group continues to exist after stop
unless it is empty.Processes will first be terminated via
SIGTERM (unless the signal to send is
changed via C<KillSignal>). Optionally, this
is immediately followed by a SIGHUP (if
enabled with C<SendSIGHUP>). If then, after a
delay (configured via the C<TimeoutStopSec>
option), processes still remain, the termination request is
repeated with the SIGKILL signal (unless
this is disabled via the C<SendSIGKILL>
option). See
L<kill(2)|"https://manpages.debian.org/cgi-bin/man.cgi?C<query>kill&C<sektion>2&C<manpath>Debian+unstable+sid">
for more information.Defaults to
control-group.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'KillSignal',
      {
        'description' => 'Specifies which signal to use when killing a
service. This controls the signal that is sent as first step
of shutting down a unit (see above), and is usually followed
by SIGKILL (see above and below). For a
list of valid signals, see
L<signal(7)|"https://manpages.debian.org/cgi-bin/man.cgi?C<query>signal&C<sektion>7&C<manpath>Debian+unstable+sid">.
Defaults to SIGTERM. Note that, right after sending the signal specified in
this setting, systemd will always send
SIGCONT, to ensure that even suspended
tasks can be terminated cleanly.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SendSIGHUP',
      {
        'description' => 'Specifies whether to send
SIGHUP to remaining processes immediately
after sending the signal configured with
C<KillSignal>. This is useful to indicate to
shells and shell-like programs that their connection has been
severed. Takes a boolean value. Defaults to "no".
',
        'type' => 'leaf',
        'value_type' => 'boolean',
        'write_as' => [
          'no',
          'yes'
        ]
      },
      'SendSIGKILL',
      {
        'description' => 'Specifies whether to send
SIGKILL to remaining processes after a
timeout, if the normal shutdown procedure left processes of
the service around. Takes a boolean value. Defaults to "yes".
',
        'type' => 'leaf',
        'value_type' => 'boolean',
        'write_as' => [
          'no',
          'yes'
        ]
      }
    ],
    'generated_by' => 'parse-man.pl from systemd doc',
    'license' => 'LGPLv2.1+',
    'name' => 'Systemd::Common::Kill'
  }
]
;

