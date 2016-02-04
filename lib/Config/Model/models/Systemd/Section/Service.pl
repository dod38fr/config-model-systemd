[
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'class_description' => 'A unit configuration file whose name ends in .service encodes information about a process controlled and supervised by systemd.

This man page lists the configuration options specific to this unit type. See L<systemd.unit(5)> for the common options of all unit configuration files. The common configuration items are configured in the generic C<[Unit]> and C<[Install]> sections. The service specific configuration options are configured in the C<[Service]> section.

Additional options are listed in L<systemd.exec(5)>, which define the execution environment the commands are executed in, and in L<systemd.kill(5)>, which define the way the processes of the service are terminated, and in L<systemd.resource-control(5)>, which configure resource control settings for the processes of the service.

If a service is requested under a certain name but no unit configuration file is found, systemd looks for a SysV init script by the same name (with the .service suffix removed) and dynamically creates a service unit from that script. This is useful for compatibility with SysV. Note that this compatibility is quite comprehensive but not 100%. For details about the incompatibilities, see the Incompatibilities with SysV document.',
    'element' => [
      'Type',
      {
        'description' => 'Configures the process start-up type for this service unit. One of simple, forking, oneshot, dbus, notify or idle.If set to simple (the default if neither C<Type> nor C<BusName>, but C<ExecStart> are specified), it is expected that the process configured with C<ExecStart> is the main process of the service. In this mode, if the process offers functionality to other processes on the system, its communication channels should be installed before the daemon is started up (e.g. sockets set up by systemd, via socket activation), as systemd will immediately proceed starting follow-up units.If set to forking, it is expected that the process configured with C<ExecStart> will call fork() as part of its start-up. The parent process is expected to exit when start-up is complete and all communication channels are set up. The child continues to run as the main daemon process. This is the behavior of traditional UNIX daemons. If this setting is used, it is recommended to also use the C<PIDFile> option, so that systemd can identify the main process of the daemon. systemd will proceed with starting follow-up units as soon as the parent process exits.Behavior of oneshot is similar to simple; however, it is expected that the process has to exit before systemd starts follow-up units. C<RemainAfterExit> is particularly useful for this type of service. This is the implied default if neither C<Type> or C<ExecStart> are specified.Behavior of dbus is similar to simple; however, it is expected that the daemon acquires a name on the D-Bus bus, as configured by C<BusName>. systemd will proceed with starting follow-up units after the D-Bus bus name has been acquired. Service units with this option configured implicitly gain dependencies on the dbus.socket unit. This type is the default if C<BusName> is specified.Behavior of notify is similar to simple; however, it is expected that the daemon sends a notification message via L<sd_notify(3)> or an equivalent call when it has finished starting up. systemd will proceed with starting follow-up units after this notification message has been sent. If this option is used, C<NotifyAccess> (see below) should be set to open access to the notification socket provided by systemd. If C<NotifyAccess> is not set, it will be implicitly set to main. Note that currently C<Type>notify will not work if used in combination with C<PrivateNetwork>yes.Behavior of idle is very similar to simple; however, actual execution of the service binary is delayed until all jobs are dispatched. This may be used to avoid interleaving of output of shell services with the status output on the console.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RemainAfterExit',
      {
        'description' => 'Takes a boolean value that specifies whether the service shall be considered active even when all its processes exited. Defaults to no.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'GuessMainPID',
      {
        'description' => 'Takes a boolean value that specifies whether systemd should try to guess the main PID of a service if it cannot be determined reliably. This option is ignored unless C<Type>forking is set and C<PIDFile> is unset because for the other types or with an explicitly configured PID file, the main PID is always known. The guessing algorithm might come to incorrect conclusions if a daemon consists of more than one process. If the main PID cannot be determined, failure detection and automatic restarting of a service will not work reliably. Defaults to yes.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'PIDFile',
      {
        'description' => 'Takes an absolute file name pointing to the PID file of this daemon. Use of this option is recommended for services where C<Type> is set to forking. systemd will read the PID of the main process of the daemon after start-up of the service. systemd will not write to the file configured here, although it will remove the file after the service has shut down if it still exists.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'BusName',
      {
        'description' => 'Takes a D-Bus bus name that this service is reachable as. This option is mandatory for services where C<Type> is set to dbus.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'BusPolicy',
      {
        'description' => 'If specified, a custom kdbus endpoint will be created and installed as the default bus node for the service. Such a custom endpoint can hold an own set of policy rules that are enforced on top of the bus-wide ones. The custom endpoint is named after the service it was created for, and its node will be bind-mounted over the default bus node location, so the service can only access the bus through its own endpoint. Note that custom bus endpoints default to a "deny all" policy. Hence, if at least one C<BusPolicy> directive is given, you have to make sure to add explicit rules for everything the service should be able to do.The value of this directive is comprised of two parts; the bus name, and a verb to specify to granted access, which is one of see, talk, or own. talk implies see, and own implies both talk and see. If multiple access levels are specified for the same bus name, the most powerful one takes effect. Examples:C<BusPolicy>org.freedesktop.systemd1 C<talkBusPolicy>org.foo.bar seeThis option is only available on kdbus enabled systems.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'ExecStart',
      {
        'description' => 'Commands with their arguments that are executed when this service is started. The value is split into zero or more command lines according to the rules described below (see section "Command Lines" below). When C<Type> is not oneshot, only one command may and must be given. When C<Type>oneshot is used, zero or more commands may be specified. This can be specified by providing multiple command lines in the same directive, or alternatively, this directive may be specified more than once with the same effect. If the empty string is assigned to this option, the list of commands to start is reset, prior assignments of this option will have no effect. If no C<ExecStart> is specified, then the service must have C<RemainAfterExit>yes set.For each of the specified commands, the first argument must be an absolute path to an executable. Optionally, if this file name is prefixed with C<@>, the second token will be passed as C<argv[0]> to the executed process, followed by the further arguments specified. If the absolute filename is prefixed with C<->, an exit code of the command normally considered a failure (i.e. non-zero exit status or abnormal exit due to signal) is ignored and considered success. If both C<-> and C<@> are used, they can appear in either order.If more than one command is specified, the commands are invoked sequentially in the order they appear in the unit file. If one of the commands fails (and is not prefixed with C<->), other lines are not executed, and the unit is considered failed.Unless C<Type>forking is set, the process started via this command line will be considered the main process of the daemon.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'ExecStartPre',
      {
        'description' => 'Additional commands that are executed before or after the command in C<ExecStart>, respectively. Syntax is the same as for C<ExecStart>, except that multiple command lines are allowed and the commands are executed one after the other, serially.If any of those commands (not prefixed with C<->) fail, the rest are not executed and the unit is considered failed.C<ExecStart> commands are only run after all C<ExecStartPre> commands that were not prefixed with a C<-> exit successfully.C<ExecStartPost> commands are only run after the service has started, as determined by C<Type> (i.e. the process has been started for C<Type>simple or C<Type>idle, the process exits successfully for C<Type>oneshot, the initial process exits successfully for C<Type>forking, C<C<READY>1> is sent for C<Type>notify, or the C<BusName> has been taken for C<Type>dbus).Note that C<ExecStartPre> may not be used to start long-running processes. All processes forked off by processes invoked via C<ExecStartPre> will be killed before the next service process is run.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'ExecReload',
      {
        'description' => 'Commands to execute to trigger a configuration reload in the service. This argument takes multiple command lines, following the same scheme as described for C<ExecStart> above. Use of this setting is optional. Specifier and environment variable substitution is supported here following the same scheme as for C<ExecStart>.One additional, special environment variable is set: if known, $MAINPID is set to the main process of the daemon, and may be used for command lines like the following:/bin/kill -HUP $MAINPIDNote however that reloading a daemon by sending a signal (as with the example line above) is usually not a good choice, because this is an asynchronous operation and hence not suitable to order reloads of multiple services against each other. It is strongly recommended to set C<ExecReload> to a command that not only triggers a configuration reload of the daemon, but also synchronously waits for it to complete.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'ExecStop',
      {
        'description' => 'Commands to execute to stop the service started via C<ExecStart>. This argument takes multiple command lines, following the same scheme as described for C<ExecStart> above. Use of this setting is optional. After the commands configured in this option are run, all processes remaining for a service are terminated according to the C<KillMode> setting (see L<systemd.kill(5)>). If this option is not specified, the process is terminated by sending the signal specified in C<KillSignal> when service stop is requested. Specifier and environment variable substitution is supported (including $MAINPID, see above).Note that it is usually not sufficient to specify a command for this setting that only asks the service to terminate (for example, by queuing some form of termination signal for it), but does not wait for it to do so. Since the remaining processes of the services are killed using SIGKILL immediately after the command exited, this would not result in a clean stop. The specified command should hence be a synchronous operation, not an asynchronous one.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'ExecStopPost',
      {
        'description' => 'Additional commands that are executed after the service was stopped. This includes cases where the commands configured in C<ExecStop> were used, where the service does not have any C<ExecStop> defined, or where the service exited unexpectedly. This argument takes multiple command lines, following the same scheme as described for C<ExecStart>. Use of these settings is optional. Specifier and environment variable substitution is supported.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RestartSec',
      {
        'description' => 'Configures the time to sleep before restarting a service (as configured with C<Restart>). Takes a unit-less value in seconds, or a time span value such as "5min 20s". Defaults to 100ms.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TimeoutStartSec',
      {
        'description' => 'Configures the time to wait for start-up. If a daemon service does not signal start-up completion within the configured time, the service will be considered failed and will be shut down again. Takes a unit-less value in seconds, or a time span value such as "5min 20s". Pass C<0> to disable the timeout logic. Defaults to C<DefaultTimeoutStartSec> from the manager configuration file, except when C<Type>oneshot is used, in which case the timeout is disabled by default (see L<systemd-system.conf(5)>).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TimeoutStopSec',
      {
        'description' => 'Configures the time to wait for stop. If a service is asked to stop, but does not terminate in the specified time, it will be terminated forcibly via SIGTERM, and after another timeout of equal duration with SIGKILL (see C<KillMode> in L<systemd.kill(5)>). Takes a unit-less value in seconds, or a time span value such as "5min 20s". Pass C<0> to disable the timeout logic. Defaults to C<DefaultTimeoutStopSec> from the manager configuration file (see L<systemd-system.conf(5)>).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TimeoutSec',
      {
        'description' => 'A shorthand for configuring both C<TimeoutStartSec> and C<TimeoutStopSec> to the specified value.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'WatchdogSec',
      {
        'description' => 'Configures the watchdog timeout for a service. The watchdog is activated when the start-up is completed. The service must call L<sd_notify(3)> regularly with C<C<WATCHDOG>1> (i.e. the "keep-alive ping"). If the time between two such calls is larger than the configured time, then the service is placed in a failed state and it will be terminated with SIGABRT. By setting C<Restart> to on-failure or always, the service will be automatically restarted. The time configured here will be passed to the executed service process in the C<WATCHDOG_USEC> environment variable. This allows daemons to automatically enable the keep-alive pinging logic if watchdog support is enabled for the service. If this option is used, C<NotifyAccess> (see below) should be set to open access to the notification socket provided by systemd. If C<NotifyAccess> is not set, it will be implicitly set to main. Defaults to 0, which disables this feature. The service can check whether the service manager expects watchdog keep-alive notifications. See L<sd_watchdog_enabled(3)> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Restart',
      {
        'description' => 'Configures whether the service shall be restarted when the service process exits, is killed, or a timeout is reached. The service process may be the main service process, but it may also be one of the processes specified with C<ExecStartPre>, C<ExecStartPost>, C<ExecStop>, C<ExecStopPost>, or C<ExecReload>. When the death of the process is a result of systemd operation (e.g. service stop or restart), the service will not be restarted. Timeouts include missing the watchdog "keep-alive ping" deadline and a service start, reload, and stop operation timeouts.Takes one of no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always. If set to no (the default), the service will not be restarted. If set to on-success, it will be restarted only when the service process exits cleanly. In this context, a clean exit means an exit code of 0, or one of the signals SIGHUP, SIGINT, SIGTERM or SIGPIPE, and additionally, exit statuses and signals specified in C<SuccessExitStatus>. If set to on-failure, the service will be restarted when the process exits with a non-zero exit code, is terminated by a signal (including on core dump, but excluding the aforementioned four signals), when an operation (such as service reload) times out, and when the configured watchdog timeout is triggered. If set to on-abnormal, the service will be restarted when the process is terminated by a signal (including on core dump, excluding the aforementioned four signals), when an operation times out, or when the watchdog timeout is triggered. If set to on-abort, the service will be restarted only if the service process exits due to an uncaught signal not specified as a clean exit status. If set to on-watchdog, the service will be restarted only if the watchdog timeout for the service expires. If set to always, the service will be restarted regardless of whether it exited cleanly or not, got terminated abnormally by a signal, or hit a timeout.Exit causes and the effect of the C<Restart> settings on themRestart settings/Exit causesnoalwayson-successon-failureon-abnormalon-aborton-watchdogClean exit code or signalXXUnclean exit codeXXUnclean signalXXXXTimeoutXXXWatchdogXXXXAs exceptions to the setting above, the service will not be restarted if the exit code or signal is specified in C<RestartPreventExitStatus> (see below). Also, the services will always be restarted if the exit code or signal is specified in C<RestartForceExitStatus> (see below).Setting this to on-failure is the recommended choice for long-running services, in order to increase reliability by attempting automatic recovery from errors. For services that shall be able to terminate on their own choice (and avoid immediate restarting), on-abnormal is an alternative choice.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SuccessExitStatus',
      {
        'description' => "Takes a list of exit status definitions that, when returned by the main service process, will be considered successful termination, in addition to the normal successful exit code 0 and the signals SIGHUP, SIGINT, SIGTERM, and SIGPIPE. Exit status definitions can either be numeric exit codes or termination signal names, separated by spaces. For example: C<SuccessExitStatus>1 2 8 SIGKILL ensures that exit codes 1, 2, 8 and the termination signal SIGKILL are considered clean service terminations. Note that if a process has a signal handler installed and exits by calling L<_exit(2)> in response to a signal, the information about the signal is lost. Programs should instead perform cleanup and kill themselves with the same signal instead. See Proper handling of SIGINT/SIGQUIT \x{2014} How to be a proper program.This option may appear more than once, in which case the list of successful exit statuses is merged. If the empty string is assigned to this option, the list is reset, all prior assignments of this option will have no effect.",
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RestartPreventExitStatus',
      {
        'description' => 'Takes a list of exit status definitions that, when returned by the main service process, will prevent automatic service restarts, regardless of the restart setting configured with C<Restart>. Exit status definitions can either be numeric exit codes or termination signal names, and are separated by spaces. Defaults to the empty list, so that, by default, no exit status is excluded from the configured restart logic. For example: C<RestartPreventExitStatus>1 6 SIGABRT ensures that exit codes 1 and 6 and the termination signal SIGABRT will not result in automatic service restarting. This option may appear more than once, in which case the list of restart-preventing statuses is merged. If the empty string is assigned to this option, the list is reset and all prior assignments of this option will have no effect.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RestartForceExitStatus',
      {
        'description' => 'Takes a list of exit status definitions that, when returned by the main service process, will force automatic service restarts, regardless of the restart setting configured with C<Restart>. The argument format is similar to C<RestartPreventExitStatus>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'PermissionsStartOnly',
      {
        'description' => 'Takes a boolean argument. If true, the permission-related execution options, as configured with C<User> and similar options (see L<systemd.exec(5)> for more information), are only applied to the process started with C<ExecStart>, and not to the various other C<ExecStartPre>, C<ExecStartPost>, C<ExecReload>, C<ExecStop>, and C<ExecStopPost> commands. If false, the setting is applied to all configured commands the same way. Defaults to false.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'RootDirectoryStartOnly',
      {
        'description' => 'Takes a boolean argument. If true, the root directory, as configured with the C<RootDirectory> option (see L<systemd.exec(5)> for more information), is only applied to the process started with C<ExecStart>, and not to the various other C<ExecStartPre>, C<ExecStartPost>, C<ExecReload>, C<ExecStop>, and C<ExecStopPost> commands. If false, the setting is applied to all configured commands the same way. Defaults to false.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'NonBlocking',
      {
        'description' => 'Set the O_NONBLOCK flag for all file descriptors passed via socket-based activation. If true, all file descriptors >= 3 (i.e. all except stdin, stdout, and stderr) will have the O_NONBLOCK flag set and hence are in non-blocking mode. This option is only useful in conjunction with a socket unit, as described in L<systemd.socket(5)>. Defaults to false.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'NotifyAccess',
      {
        'description' => 'Controls access to the service status notification socket, as accessible via the L<sd_notify(3)> call. Takes one of none (the default), main or all. If none, no daemon status updates are accepted from the service processes, all status update messages are ignored. If main, only service updates sent from the main process of the service are accepted. If all, all services updates from all members of the service\'s control group are accepted. This option should be set to open access to the notification socket when using C<Type>notify or C<WatchdogSec> (see above). If those options are used but C<NotifyAccess> is not configured, it will be implicitly set to main.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Sockets',
      {
        'description' => 'Specifies the name of the socket units this service shall inherit socket file descriptors from when the service is started. Normally, it should not be necessary to use this setting, as all socket file descriptors whose unit shares the same name as the service (subject to the different unit name suffix of course) are passed to the spawned process.Note that the same socket file descriptors may be passed to multiple processes simultaneously. Also note that a different service may be activated on incoming socket traffic than the one which is ultimately configured to inherit the socket file descriptors. Or, in other words: the C<Service> setting of .socket units does not have to match the inverse of the C<Sockets> setting of the .service it refers to.This option may appear more than once, in which case the list of socket units is merged. If the empty string is assigned to this option, the list of sockets is reset, and all prior uses of this setting will have no effect.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'StartLimitInterval',
      {
        'description' => 'Configure service start rate limiting. By default, services which are started more than 5 times within 10 seconds are not permitted to start any more times until the 10 second interval ends. With these two options, this rate limiting may be modified. Use C<StartLimitInterval> to configure the checking interval (defaults to C<DefaultStartLimitInterval> in manager configuration file, set to 0 to disable any kind of rate limiting). Use C<StartLimitBurst> to configure how many starts per interval are allowed (defaults to C<DefaultStartLimitBurst> in manager configuration file). These configuration options are particularly useful in conjunction with C<Restart>; however, they apply to all kinds of starts (including manual), not just those triggered by the C<Restart> logic. Note that units which are configured for C<Restart> and which reach the start limit are not attempted to be restarted anymore; however, they may still be restarted manually at a later point, from which point on, the restart logic is again activated. Note that systemctl reset-failed will cause the restart rate counter for a service to be flushed, which is useful if the administrator wants to manually start a service and the start limit interferes with that.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'StartLimitAction',
      {
        'description' => 'Configure the action to take if the rate limit configured with C<StartLimitInterval> and C<StartLimitBurst> is hit. Takes one of none, reboot, reboot-force, reboot-immediate, poweroff, poweroff-force or poweroff-immediate. If none is set, hitting the rate limit will trigger no action besides that the start will not be permitted. reboot causes a reboot following the normal shutdown procedure (i.e. equivalent to systemctl reboot). reboot-force causes a forced reboot which will terminate all processes forcibly but should cause no dirty file systems on reboot (i.e. equivalent to systemctl reboot -f) and reboot-immediate causes immediate execution of the L<reboot(2)> system call, which might result in data loss. Similarly, poweroff, poweroff-force, poweroff-immediate have the effect of powering down the system with similar semantics. Defaults to none.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'FailureAction',
      {
        'description' => 'Configure the action to take when the service enters a failed state. Takes the same values as C<StartLimitAction> and executes the same actions. Defaults to none.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RebootArgument',
      {
        'description' => 'Configure the optional argument for the L<reboot(2)> system call if C<StartLimitAction> or C<FailureAction> is a reboot action. This works just like the optional argument to systemctl reboot command.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'FileDescriptorStoreMax',
      {
        'description' => 'Configure how many file descriptors may be stored in the service manager for the service using L<sd_pid_notify_with_fds(3)>\'s C<C<FDSTORE>1> messages. This is useful for implementing service restart schemes where the state is serialized to /run and the file descriptors passed to the service manager, to allow restarts without losing state. Defaults to 0, i.e. no file descriptors may be stored in the service manager by default. All file descriptors passed to the service manager from a specific service are passed back to the service\'s main process on the next service restart. Any file descriptors passed to the service manager are automatically closed when POLLHUP or POLLERR is seen on them, or when the service is fully stopped and no job queued or being executed for it.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'USBFunctionDescriptors',
      {
        'description' => 'Configure the location of a file containing USB FunctionFS descriptors, for implementation of USB gadget functions. This is used only in conjunction with a socket unit with C<ListenUSBFunction> configured. The contents of this file are written to the ep0 file after it is opened.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'USBFunctionStrings',
      {
        'description' => 'Configure the location of a file containing USB FunctionFS strings. Behavior is similar to C<USBFunctionDescriptors> above.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'include' => [
      'Systemd::Common::ResourceControl',
      'Systemd::Common::Exec',
      'Systemd::Common::Kill'
    ],
    'name' => 'Systemd::Section::Service'
  }
]
;

