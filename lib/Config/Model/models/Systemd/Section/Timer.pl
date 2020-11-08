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
    'class_description' => 'A unit configuration file whose name ends in
C<.timer> encodes information about a timer
controlled and supervised by systemd, for timer-based
activation.

This man page lists the configuration options specific to
this unit type. See
L<systemd.unit(5)>
for the common options of all unit configuration files. The common
configuration items are configured in the generic [Unit] and
[Install] sections. The timer specific configuration options are
configured in the [Timer] section.

For each timer file, a matching unit file must exist,
describing the unit to activate when the timer elapses. By
default, a service by the same name as the timer (except for the
suffix) is activated. Example: a timer file
C<foo.timer> activates a matching service
C<foo.service>. The unit to activate may be
controlled by C<Unit> (see below).

Note that in case the unit to activate is already active at the time the timer elapses it is not restarted,
but simply left running. There is no concept of spawning new service instances in this case. Due to this, services
with C<RemainAfterExit> set (which stay around continuously even after the service\'s main process
exited) are usually not suitable for activation via repetitive timers, as they will only be activated once, and
then stay around forever.
This configuration class was generated from systemd documentation.
by L<parse-man.pl|https://github.com/dod38fr/config-model-systemd/contrib/parse-man.pl>
',
    'copyright' => [
      '2010-2016 Lennart Poettering and others',
      '2016 Dominique Dumont'
    ],
    'element' => [
      'OnActiveSec',
      {
        'description' => 'Defines monotonic timers relative to different
starting points:

Multiple directives may be combined of the same and of different types, in which case the timer
unit will trigger whenever any of the specified timer expressions elapse. For example, by combining
C<OnBootSec> and C<OnUnitActiveSec>, it is possible to define a
timer that elapses in regular intervals and activates a specific service each time. Moreover, both
monotonic time expressions and C<OnCalendar> calendar expressions may be combined in
the same timer unit.

The arguments to the directives are time spans
configured in seconds. Example: "OnBootSec=50" means 50s after
boot-up. The argument may also include time units. Example:
"OnBootSec=5h 30min" means 5 hours and 30 minutes after
boot-up. For details about the syntax of time spans, see
L<systemd.time(7)>.

If a timer configured with C<OnBootSec>
or C<OnStartupSec> is already in the past
when the timer unit is activated, it will immediately elapse
and the configured unit is started. This is not the case for
timers defined in the other directives.

These are monotonic timers, independent of wall-clock time and timezones. If the computer is
temporarily suspended, the monotonic clock generally pauses, too. Note that if
C<WakeSystem> is used, a different monotonic clock is selected that continues to
advance while the system is suspended and thus can be used as the trigger to resume the
system.

If the empty string is assigned to any of these options, the list of timers is reset (both
monotonic timers and C<OnCalendar> timers, see below), and all prior assignments
will have no effect.

Note that timers do not necessarily expire at the
precise time configured with these settings, as they are
subject to the C<AccuracySec> setting
below.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnBootSec',
      {
        'description' => 'Defines monotonic timers relative to different
starting points:

Multiple directives may be combined of the same and of different types, in which case the timer
unit will trigger whenever any of the specified timer expressions elapse. For example, by combining
C<OnBootSec> and C<OnUnitActiveSec>, it is possible to define a
timer that elapses in regular intervals and activates a specific service each time. Moreover, both
monotonic time expressions and C<OnCalendar> calendar expressions may be combined in
the same timer unit.

The arguments to the directives are time spans
configured in seconds. Example: "OnBootSec=50" means 50s after
boot-up. The argument may also include time units. Example:
"OnBootSec=5h 30min" means 5 hours and 30 minutes after
boot-up. For details about the syntax of time spans, see
L<systemd.time(7)>.

If a timer configured with C<OnBootSec>
or C<OnStartupSec> is already in the past
when the timer unit is activated, it will immediately elapse
and the configured unit is started. This is not the case for
timers defined in the other directives.

These are monotonic timers, independent of wall-clock time and timezones. If the computer is
temporarily suspended, the monotonic clock generally pauses, too. Note that if
C<WakeSystem> is used, a different monotonic clock is selected that continues to
advance while the system is suspended and thus can be used as the trigger to resume the
system.

If the empty string is assigned to any of these options, the list of timers is reset (both
monotonic timers and C<OnCalendar> timers, see below), and all prior assignments
will have no effect.

Note that timers do not necessarily expire at the
precise time configured with these settings, as they are
subject to the C<AccuracySec> setting
below.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnStartupSec',
      {
        'description' => 'Defines monotonic timers relative to different
starting points:

Multiple directives may be combined of the same and of different types, in which case the timer
unit will trigger whenever any of the specified timer expressions elapse. For example, by combining
C<OnBootSec> and C<OnUnitActiveSec>, it is possible to define a
timer that elapses in regular intervals and activates a specific service each time. Moreover, both
monotonic time expressions and C<OnCalendar> calendar expressions may be combined in
the same timer unit.

The arguments to the directives are time spans
configured in seconds. Example: "OnBootSec=50" means 50s after
boot-up. The argument may also include time units. Example:
"OnBootSec=5h 30min" means 5 hours and 30 minutes after
boot-up. For details about the syntax of time spans, see
L<systemd.time(7)>.

If a timer configured with C<OnBootSec>
or C<OnStartupSec> is already in the past
when the timer unit is activated, it will immediately elapse
and the configured unit is started. This is not the case for
timers defined in the other directives.

These are monotonic timers, independent of wall-clock time and timezones. If the computer is
temporarily suspended, the monotonic clock generally pauses, too. Note that if
C<WakeSystem> is used, a different monotonic clock is selected that continues to
advance while the system is suspended and thus can be used as the trigger to resume the
system.

If the empty string is assigned to any of these options, the list of timers is reset (both
monotonic timers and C<OnCalendar> timers, see below), and all prior assignments
will have no effect.

Note that timers do not necessarily expire at the
precise time configured with these settings, as they are
subject to the C<AccuracySec> setting
below.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnUnitActiveSec',
      {
        'description' => 'Defines monotonic timers relative to different
starting points:

Multiple directives may be combined of the same and of different types, in which case the timer
unit will trigger whenever any of the specified timer expressions elapse. For example, by combining
C<OnBootSec> and C<OnUnitActiveSec>, it is possible to define a
timer that elapses in regular intervals and activates a specific service each time. Moreover, both
monotonic time expressions and C<OnCalendar> calendar expressions may be combined in
the same timer unit.

The arguments to the directives are time spans
configured in seconds. Example: "OnBootSec=50" means 50s after
boot-up. The argument may also include time units. Example:
"OnBootSec=5h 30min" means 5 hours and 30 minutes after
boot-up. For details about the syntax of time spans, see
L<systemd.time(7)>.

If a timer configured with C<OnBootSec>
or C<OnStartupSec> is already in the past
when the timer unit is activated, it will immediately elapse
and the configured unit is started. This is not the case for
timers defined in the other directives.

These are monotonic timers, independent of wall-clock time and timezones. If the computer is
temporarily suspended, the monotonic clock generally pauses, too. Note that if
C<WakeSystem> is used, a different monotonic clock is selected that continues to
advance while the system is suspended and thus can be used as the trigger to resume the
system.

If the empty string is assigned to any of these options, the list of timers is reset (both
monotonic timers and C<OnCalendar> timers, see below), and all prior assignments
will have no effect.

Note that timers do not necessarily expire at the
precise time configured with these settings, as they are
subject to the C<AccuracySec> setting
below.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnUnitInactiveSec',
      {
        'description' => 'Defines monotonic timers relative to different
starting points:

Multiple directives may be combined of the same and of different types, in which case the timer
unit will trigger whenever any of the specified timer expressions elapse. For example, by combining
C<OnBootSec> and C<OnUnitActiveSec>, it is possible to define a
timer that elapses in regular intervals and activates a specific service each time. Moreover, both
monotonic time expressions and C<OnCalendar> calendar expressions may be combined in
the same timer unit.

The arguments to the directives are time spans
configured in seconds. Example: "OnBootSec=50" means 50s after
boot-up. The argument may also include time units. Example:
"OnBootSec=5h 30min" means 5 hours and 30 minutes after
boot-up. For details about the syntax of time spans, see
L<systemd.time(7)>.

If a timer configured with C<OnBootSec>
or C<OnStartupSec> is already in the past
when the timer unit is activated, it will immediately elapse
and the configured unit is started. This is not the case for
timers defined in the other directives.

These are monotonic timers, independent of wall-clock time and timezones. If the computer is
temporarily suspended, the monotonic clock generally pauses, too. Note that if
C<WakeSystem> is used, a different monotonic clock is selected that continues to
advance while the system is suspended and thus can be used as the trigger to resume the
system.

If the empty string is assigned to any of these options, the list of timers is reset (both
monotonic timers and C<OnCalendar> timers, see below), and all prior assignments
will have no effect.

Note that timers do not necessarily expire at the
precise time configured with these settings, as they are
subject to the C<AccuracySec> setting
below.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnCalendar',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Defines realtime (i.e. wallclock) timers with
calendar event expressions. See
L<systemd.time(7)>
for more information on the syntax of calendar event
expressions. Otherwise, the semantics are similar to
C<OnActiveSec> and related settings.

Note that timers do not necessarily expire at the
precise time configured with this setting, as it is subject to
the C<AccuracySec> setting
below.

May be specified more than once, in which case the timer unit will trigger whenever any of the
specified expressions elapse. Moreover calendar timers and monotonic timers (see above) may be
combined within the same timer unit.

If the empty string is assigned to any of these options, the list of timers is reset (both
C<OnCalendar> timers and monotonic timers, see above), and all prior assignments
will have no effect.',
        'type' => 'list'
      },
      'AccuracySec',
      {
        'description' => 'Specify the accuracy the timer shall elapse
with. Defaults to 1min. The timer is scheduled to elapse
within a time window starting with the time specified in
C<OnCalendar>,
C<OnActiveSec>,
C<OnBootSec>,
C<OnStartupSec>,
C<OnUnitActiveSec> or
C<OnUnitInactiveSec> and ending the time
configured with C<AccuracySec> later. Within
this time window, the expiry time will be placed at a
host-specific, randomized, but stable position that is
synchronized between all local timer units. This is done in
order to optimize power consumption to suppress unnecessary
CPU wake-ups. To get best accuracy, set this option to
1us. Note that the timer is still subject to the timer slack
configured via
L<systemd-system.conf(5)>\'s
C<TimerSlackNSec> setting. See
L<prctl(2)>
for details. To optimize power consumption, make sure to set
this value as high as possible and as low as
necessary.

Note that this setting is primarily a power saving option that allows coalescing CPU
wake-ups. It should not be confused with C<RandomizedDelaySec> (see below) which
adds a random value to the time the timer shall elapse next and whose purpose is the opposite: to
stretch elapsing of timer events over a longer period to reduce workload spikes. For further details
and explanations and how both settings play together, see below.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RandomizedDelaySec',
      {
        'description' => 'Delay the timer by a randomly selected, evenly
distributed amount of time between 0 and the specified time
value. Defaults to 0, indicating that no randomized delay
shall be applied. Each timer unit will determine this delay
randomly before each iteration, and the delay will simply be
added on top of the next determined elapsing time. This is
useful to stretch dispatching of similarly configured timer
events over a certain amount time, to avoid that they all fire
at the same time, possibly resulting in resource
congestion. Note the relation to
C<AccuracySec> above: the latter allows the
service manager to coalesce timer events within a specified
time range in order to minimize wakeups, the former does the
opposite: it stretches timer events over a time range, to make
it unlikely that they fire simultaneously. If
C<RandomizedDelaySec> and
C<AccuracySec> are used in conjunction, first
the randomized delay is added, and then the result is
possibly further shifted to coalesce it with other timer
events happening on the system. As mentioned above
C<AccuracySec> defaults to 1min and
C<RandomizedDelaySec> to 0, thus encouraging
coalescing of timer events. In order to optimally stretch
timer events over a certain range of time, make sure to set
C<RandomizedDelaySec> to a higher value, and
C<AccuracySec=1us>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnClockChange',
      {
        'description' => 'These options take boolean arguments. When true, the service unit will be triggered
when the system clock (C<CLOCK_REALTIME>) jumps relative to the monotonic clock
(C<CLOCK_MONOTONIC>), or when the local system timezone is modified. These options
can be used alone or in combination with other timer expressions (see above) within the same timer
unit. These options default to false.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'OnTimezoneChange',
      {
        'description' => 'These options take boolean arguments. When true, the service unit will be triggered
when the system clock (C<CLOCK_REALTIME>) jumps relative to the monotonic clock
(C<CLOCK_MONOTONIC>), or when the local system timezone is modified. These options
can be used alone or in combination with other timer expressions (see above) within the same timer
unit. These options default to false.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Unit',
      {
        'description' => 'The unit to activate when this timer elapses.
The argument is a unit name, whose suffix is not
C<.timer>. If not specified, this value
defaults to a service that has the same name as the timer
unit, except for the suffix. (See above.) It is recommended
that the unit name that is activated and the unit name of the
timer unit are named identically, except for the
suffix.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Persistent',
      {
        'description' => "Takes a boolean argument. If true, the time when the service unit was last triggered
is stored on disk.  When the timer is activated, the service unit is triggered immediately if it
would have been triggered at least once during the time when the timer was inactive. Such triggering
is nonetheless subject to the delay imposed by C<RandomizedDelaySec>.
This is useful to catch up on missed runs of the service when the system was powered down. Note that
this setting only has an effect on timers configured with C<OnCalendar>. Defaults to
C<false>.

Use systemctl clean --what=state \x{2026} on the timer unit to remove the timestamp
file maintained by this option from disk. In particular, use this command before uninstalling a timer
unit. See
L<systemctl(1)> for
details.",
        'type' => 'leaf',
        'value_type' => 'boolean',
        'write_as' => [
          'no',
          'yes'
        ]
      },
      'WakeSystem',
      {
        'description' => 'Takes a boolean argument. If true, an elapsing timer will cause the system to resume
from suspend, should it be suspended and if the system supports this. Note that this option will only
make sure the system resumes on the appropriate times, it will not take care of suspending it again
after any work that is to be done is finished. Defaults to
C<false>.

Note that this functionality requires privileges and is thus generally only available in the
system service manager.

Note that behaviour of monotonic clock timers (as configured with
C<OnActiveSec>, C<OnBootSec>, C<OnStartupSec>,
C<OnUnitActiveSec>, C<OnUnitInactiveSec>, see above) is altered
depending on this option. If false, a monotonic clock is used that is paused during system suspend
(C<CLOCK_MONOTONIC>), if true a different monotonic clock is used that continues
advancing during system suspend (C<CLOCK_BOOTTIME>), see
L<clock_getres(2)> for
details.',
        'type' => 'leaf',
        'value_type' => 'boolean',
        'write_as' => [
          'no',
          'yes'
        ]
      },
      'RemainAfterElapse',
      {
        'description' => 'Takes a boolean argument. If true, a timer will stay loaded, and its state remains
queryable even after it elapsed and the associated unit (as configured with C<Unit>,
see above) deactivated again. If false, an elapsed timer unit that cannot elapse anymore is unloaded
once its associated unit deactivated again. Turning this off is particularly useful for transient
timer units. Note that this setting has an effect when repeatedly starting a timer unit: if
C<RemainAfterElapse> is on, starting the timer a second time has no effect. However,
if C<RemainAfterElapse> is off and the timer unit was already unloaded, it can be
started again, and thus the service can be triggered multiple times. Defaults to
C<yes>.',
        'type' => 'leaf',
        'value_type' => 'boolean',
        'write_as' => [
          'no',
          'yes'
        ]
      }
    ],
    'generated_by' => 'parse-man.pl from systemd 246 doc',
    'license' => 'LGPLv2.1+',
    'name' => 'Systemd::Section::Timer'
  }
]
;

