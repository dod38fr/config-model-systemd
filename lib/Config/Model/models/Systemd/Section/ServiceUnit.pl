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
      'FailureAction',
      {
        'choice' => [
          'none',
          'reboot',
          'reboot-force',
          'reboot-immediate',
          'poweroff',
          'poweroff-force',
          'poweroff-immediate',
          'exit',
          'exit-force'
        ],
        'description' => 'Configure the action to take when the unit stops and enters a failed state or inactive state.
Takes one of C<none>, C<reboot>, C<reboot-force>,
C<reboot-immediate>, C<poweroff>, C<poweroff-force>,
C<poweroff-immediate>, C<exit>, and C<exit-force>. In system mode,
all options are allowed. In user mode, only C<none>, C<exit>, and
C<exit-force> are allowed. Both options default to C<none>.

If C<none> is set, no action will be triggered. C<reboot> causes a reboot
following the normal shutdown procedure (i.e. equivalent to systemctl reboot).
C<reboot-force> causes a forced reboot which will terminate all processes forcibly but should
cause no dirty file systems on reboot (i.e. equivalent to systemctl reboot -f) and
C<reboot-immediate> causes immediate execution of the
L<reboot(2)> system call, which
might result in data loss (i.e. equivalent to systemctl reboot -ff). Similarly,
C<poweroff>, C<poweroff-force>, C<poweroff-immediate> have the effect
of powering down the system with similar semantics. C<exit> causes the manager to exit following
the normal shutdown procedure, and C<exit-force> causes it terminate without shutting down
services. When C<exit> or C<exit-force> is used by default the exit status of the
main process of the unit (if this applies) is returned from the service manager. However, this may be overriden
with C<FailureActionExitStatus>/C<SuccessActionExitStatus>, see
below.',
        'migrate_from' => {
          'formula' => '$service',
          'variables' => {
            'service' => '- - Service FailureAction'
          }
        },
        'type' => 'leaf',
        'value_type' => 'enum'
      },
      'SuccessAction',
      {
        'choice' => [
          'none',
          'reboot',
          'reboot-force',
          'reboot-immediate',
          'poweroff',
          'poweroff-force',
          'poweroff-immediate',
          'exit',
          'exit-force'
        ],
        'description' => 'Configure the action to take when the unit stops and enters a failed state or inactive state.
Takes one of C<none>, C<reboot>, C<reboot-force>,
C<reboot-immediate>, C<poweroff>, C<poweroff-force>,
C<poweroff-immediate>, C<exit>, and C<exit-force>. In system mode,
all options are allowed. In user mode, only C<none>, C<exit>, and
C<exit-force> are allowed. Both options default to C<none>.

If C<none> is set, no action will be triggered. C<reboot> causes a reboot
following the normal shutdown procedure (i.e. equivalent to systemctl reboot).
C<reboot-force> causes a forced reboot which will terminate all processes forcibly but should
cause no dirty file systems on reboot (i.e. equivalent to systemctl reboot -f) and
C<reboot-immediate> causes immediate execution of the
L<reboot(2)> system call, which
might result in data loss (i.e. equivalent to systemctl reboot -ff). Similarly,
C<poweroff>, C<poweroff-force>, C<poweroff-immediate> have the effect
of powering down the system with similar semantics. C<exit> causes the manager to exit following
the normal shutdown procedure, and C<exit-force> causes it terminate without shutting down
services. When C<exit> or C<exit-force> is used by default the exit status of the
main process of the unit (if this applies) is returned from the service manager. However, this may be overriden
with C<FailureActionExitStatus>/C<SuccessActionExitStatus>, see
below.',
        'migrate_from' => {
          'formula' => '$service',
          'variables' => {
            'service' => '- - Service SuccessAction'
          }
        },
        'type' => 'leaf',
        'value_type' => 'enum'
      },
      'StartLimitBurst',
      {
        'description' => 'Configure unit start rate limiting. Units which are started more than
burst times within an interval time interval are not
permitted to start any more. Use C<StartLimitIntervalSec> to configure the checking interval
(defaults to C<DefaultStartLimitIntervalSec> in manager configuration file, set it to 0 to
disable any kind of rate limiting). Use C<StartLimitBurst> to configure how many starts per
interval are allowed (defaults to C<DefaultStartLimitBurst> in manager configuration
file). These configuration options are particularly useful in conjunction with the service setting
C<Restart> (see
L<systemd.service(5)>); however,
they apply to all kinds of starts (including manual), not just those triggered by the
C<Restart> logic. Note that units which are configured for C<Restart> and
which reach the start limit are not attempted to be restarted anymore; however, they may still be restarted
manually at a later point, after the interval has passed.  From this point on, the
restart logic is activated again. Note that systemctl reset-failed will cause the restart
rate counter for a service to be flushed, which is useful if the administrator wants to manually start a unit
and the start limit interferes with that. Note that this rate-limiting is enforced after any unit condition
checks are executed, and hence unit activations with failing conditions do not count towards this rate
limit. This setting does not apply to slice, target, device, and scope units, since they are unit types whose
activation may either never fail, or may succeed only a single time.

When a unit is unloaded due to the garbage collection logic (see above) its rate limit counters are
flushed out too. This means that configuring start rate limiting for a unit that is not referenced continuously
has no effect.',
        'migrate_from' => {
          'formula' => '$service',
          'variables' => {
            'service' => '- - Service StartLimitBurst'
          }
        },
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'StartLimitIntervalSec',
      {
        'description' => 'Configure unit start rate limiting. Units which are started more than
burst times within an interval time interval are not
permitted to start any more. Use C<StartLimitIntervalSec> to configure the checking interval
(defaults to C<DefaultStartLimitIntervalSec> in manager configuration file, set it to 0 to
disable any kind of rate limiting). Use C<StartLimitBurst> to configure how many starts per
interval are allowed (defaults to C<DefaultStartLimitBurst> in manager configuration
file). These configuration options are particularly useful in conjunction with the service setting
C<Restart> (see
L<systemd.service(5)>); however,
they apply to all kinds of starts (including manual), not just those triggered by the
C<Restart> logic. Note that units which are configured for C<Restart> and
which reach the start limit are not attempted to be restarted anymore; however, they may still be restarted
manually at a later point, after the interval has passed.  From this point on, the
restart logic is activated again. Note that systemctl reset-failed will cause the restart
rate counter for a service to be flushed, which is useful if the administrator wants to manually start a unit
and the start limit interferes with that. Note that this rate-limiting is enforced after any unit condition
checks are executed, and hence unit activations with failing conditions do not count towards this rate
limit. This setting does not apply to slice, target, device, and scope units, since they are unit types whose
activation may either never fail, or may succeed only a single time.

When a unit is unloaded due to the garbage collection logic (see above) its rate limit counters are
flushed out too. This means that configuring start rate limiting for a unit that is not referenced continuously
has no effect.',
        'migrate_from' => {
          'formula' => '$unit || $service',
          'use_eval' => '1',
          'variables' => {
            'service' => '- - Service StartLimitInterval',
            'unit' => '- StartLimitInterval'
          }
        },
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RebootArgument',
      {
        'description' => 'Configure the optional argument for the
L<reboot(2)> system call if
C<StartLimitAction> or C<FailureAction> is a reboot action. This
works just like the optional argument to systemctl reboot command.',
        'migrate_from' => {
          'formula' => '$service',
          'variables' => {
            'service' => '- - Service RebootArgument'
          }
        },
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'include' => [
      'Systemd::Section::Unit'
    ],
    'name' => 'Systemd::Section::ServiceUnit'
  }
]
;

