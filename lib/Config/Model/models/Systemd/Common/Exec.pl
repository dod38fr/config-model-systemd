[
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'class_description' => 'Unit configuration files for services, sockets, mount points, and swap devices share a subset of configuration options which define the execution environment of spawned processes.

This man page lists the configuration options shared by these four unit types. See L<systemd.unit(5)> for the common options of all unit configuration files, and L<systemd.service(5)>, L<systemd.socket(5)>, L<systemd.swap(5)>, and L<systemd.mount(5)> for more information on the specific unit configuration files. The execution specific configuration options are configured in the [Service], [Socket], [Mount], or [Swap] sections, depending on the unit type.',
    'element' => [
      'WorkingDirectory',
      {
        'description' => 'Takes an absolute directory path, or the special value C<~>. Sets the working directory for executed processes. If set to C<~>, the home directory of the user specified in C<User> is used. If not set, defaults to the root directory when systemd is running as a system instance and the respective user\'s home directory if run as user. If the setting is prefixed with the C<-> character, a missing working directory is not considered fatal. Note that setting this parameter might result in additional dependencies to be added to the unit (see above).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RootDirectory',
      {
        'description' => 'Takes an absolute directory path. Sets the root directory for executed processes, with the L<chroot(2)> system call. If this is used, it must be ensured that the process binary and all its auxiliary files are available in the chroot() jail. Note that setting this parameter might result in additional dependencies to be added to the unit (see above).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'User',
      {
        'description' => 'Sets the Unix user or group that the processes are executed as, respectively. Takes a single user or group name or ID as argument. If no group is set, the default group of the user is chosen.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SupplementaryGroups',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Sets the supplementary Unix groups the processes are executed as. This takes a space-separated list of group names or IDs. This option may be specified more than once, in which case all listed groups are set as supplementary groups. When the empty string is assigned, the list of supplementary groups is reset, and all assignments prior to this one will have no effect. In any way, this option does not override, but extends the list of supplementary groups configured in the system group database for the user.',
        'type' => 'list'
      },
      'Nice',
      {
        'description' => 'Sets the default nice level (scheduling priority) for executed processes. Takes an integer between -20 (highest priority) and 19 (lowest priority). See L<setpriority(2)> for details.',
        'max' => '1',
        'min' => '-20',
        'type' => 'leaf',
        'value_type' => 'integer'
      },
      'OOMScoreAdjust',
      {
        'description' => 'Sets the adjustment level for the Out-Of-Memory killer for executed processes. Takes an integer between -1000 (to disable OOM killing for this process) and 1000 (to make killing of this process under memory pressure very likely). See proc.txt for details.',
        'max' => '1',
        'min' => '-1000',
        'type' => 'leaf',
        'value_type' => 'integer'
      },
      'IOSchedulingClass',
      {
        'description' => 'Sets the I/O scheduling class for executed processes. Takes an integer between 0 and 3 or one of the strings none, realtime, best-effort or idle. See L<ioprio_set(2)> for details.',
        'type' => 'leaf',
        'value_type' => 'integer'
      },
      'IOSchedulingPriority',
      {
        'description' => 'Sets the I/O scheduling priority for executed processes. Takes an integer between 0 (highest priority) and 7 (lowest priority). The available priorities depend on the selected I/O scheduling class (see above). See L<ioprio_set(2)> for details.',
        'max' => '7',
        'min' => '0',
        'type' => 'leaf',
        'value_type' => 'integer'
      },
      'CPUSchedulingPolicy',
      {
        'description' => 'Sets the CPU scheduling policy for executed processes. Takes one of other, batch, idle, fifo or rr. See L<sched_setscheduler(2)> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'CPUSchedulingPriority',
      {
        'description' => 'Sets the CPU scheduling priority for executed processes. The available priority range depends on the selected CPU scheduling policy (see above). For real-time scheduling policies an integer between 1 (lowest priority) and 99 (highest priority) can be used. See L<sched_setscheduler(2)> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'CPUSchedulingResetOnFork',
      {
        'description' => 'Takes a boolean argument. If true, elevated CPU scheduling priorities and policies will be reset when the executed processes fork, and can hence not leak into child processes. See L<sched_setscheduler(2)> for details. Defaults to false.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'CPUAffinity',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Controls the CPU affinity of the executed processes. Takes a list of CPU indices or ranges separated by either whitespace or commas. CPU ranges are specified by the lower and upper CPU indices separated by a dash. This option may be specified more than once, in which case the specified CPU affinity masks are merged. If the empty string is assigned, the mask is reset, all assignments prior to this will have no effect. See L<sched_setaffinity(2)> for details.',
        'type' => 'list'
      },
      'UMask',
      {
        'description' => 'Controls the file mode creation mask. Takes an access mode in octal notation. See L<umask(2)> for details. Defaults to 0022.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Environment',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Sets environment variables for executed processes. Takes a space-separated list of variable assignments. This option may be specified more than once, in which case all listed variables will be set. If the same variable is set twice, the later setting will override the earlier setting. If the empty string is assigned to this option, the list of environment variables is reset, all prior assignments have no effect. Variable expansion is not performed inside the strings, however, specifier expansion is possible. The $ character has no special meaning. If you need to assign a value containing spaces to a variable, use double quotes (") for the assignment.Example: C<Environment>"C<VAR1>word1 word2" C<VAR2>word3 "C<VAR3>$word 5 6" gives three variables C<VAR1>, C<VAR2>, C<VAR3> with the values C<word1 word2>, C<word3>, C<$word 5 6>. See L<environ(7)> for details about environment variables.',
        'type' => 'list'
      },
      'EnvironmentFile',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Similar to C<Environment> but reads the environment variables from a text file. The text file should contain new-line-separated variable assignments. Empty lines, lines without an C<=> separator, or lines starting with ; or # will be ignored, which may be used for commenting. A line ending with a backslash will be concatenated with the following one, allowing multiline variable definitions. The parser strips leading and trailing whitespace from the values of assignments, unless you use double quotes (").The argument passed should be an absolute filename or wildcard expression, optionally prefixed with C<->, which indicates that if the file does not exist, it will not be read and no error or warning message is logged. This option may be specified more than once in which case all specified files are read. If the empty string is assigned to this option, the list of file to read is reset, all prior assignments have no effect.The files listed with this directive will be read shortly before the process is executed (more specifically, after all processes from a previous unit state terminated. This means you can generate these files in one unit state, and read it with this option in the next).Settings from these files override settings made with C<Environment>. If the same variable is set twice from these files, the files will be read in the order they are specified and the later setting will override the earlier setting.',
        'type' => 'list'
      },
      'PassEnvironment',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Pass environment variables from the systemd system manager to executed processes. Takes a space-separated list of variable names. This option may be specified more than once, in which case all listed variables will be set. If the empty string is assigned to this option, the list of environment variables is reset, all prior assignments have no effect. Variables that are not set in the system manager will not be passed and will be silently ignored.Variables passed from this setting are overridden by those passed from C<Environment> or C<EnvironmentFile>.Example: C<PassEnvironment>VAR1 VAR2 VAR3 passes three variables C<VAR1>, C<VAR2>, C<VAR3> with the values set for those variables in PID1. See L<environ(7)> for details about environment variables.',
        'type' => 'list'
      },
      'StandardInput',
      {
        'description' => 'Controls where file descriptor 0 (STDIN) of the executed processes is connected to. Takes one of null, tty, tty-force, tty-fail or socket.If null is selected, standard input will be connected to /dev/null, i.e. all read attempts by the process will result in immediate EOF.If tty is selected, standard input is connected to a TTY (as configured by C<TTYPath>, see below) and the executed process becomes the controlling process of the terminal. If the terminal is already being controlled by another process, the executed process waits until the current controlling process releases the terminal.tty-force is similar to tty, but the executed process is forcefully and immediately made the controlling process of the terminal, potentially removing previous controlling processes from the terminal.tty-fail is similar to tty but if the terminal already has a controlling process start-up of the executed process fails.The socket option is only valid in socket-activated services, and only when the socket configuration file (see L<systemd.socket(5)> for details) specifies a single socket only. If this option is set, standard input will be connected to the socket the service was activated from, which is primarily useful for compatibility with daemons designed for use with the traditional L<inetd(8)> daemon.This setting defaults to null.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'StandardOutput',
      {
        'description' => 'Controls where file descriptor 1 (STDOUT) of the executed processes is connected to. Takes one of inherit, null, tty, journal, syslog, kmsg, journal+console, syslog+console, kmsg+console or socket.inherit duplicates the file descriptor of standard input for standard output.null connects standard output to /dev/null, i.e. everything written to it will be lost.tty connects standard output to a tty (as configured via C<TTYPath>, see below). If the TTY is used for output only, the executed process will not become the controlling process of the terminal, and will not fail or wait for other processes to release the terminal.journal connects standard output with the journal which is accessible via L<journalctl(1)>. Note that everything that is written to syslog or kmsg (see below) is implicitly stored in the journal as well, the specific two options listed below are hence supersets of this one.syslog connects standard output to the L<syslog(3)> system syslog service, in addition to the journal. Note that the journal daemon is usually configured to forward everything it receives to syslog anyway, in which case this option is no different from journal.kmsg connects standard output with the kernel log buffer which is accessible via L<dmesg(1)>, in addition to the journal. The journal daemon might be configured to send all logs to kmsg anyway, in which case this option is no different from journal.journal+console, syslog+console and kmsg+console work in a similar way as the three options above but copy the output to the system console as well.socket connects standard output to a socket acquired via socket activation. The semantics are similar to the same option of C<StandardInput>.This setting defaults to the value set with C<DefaultStandardOutput> in L<systemd-system.conf(5)>, which defaults to journal. Note that setting this parameter might result in additional dependencies to be added to the unit (see above).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'StandardError',
      {
        'description' => 'Controls where file descriptor 2 (STDERR) of the executed processes is connected to. The available options are identical to those of C<StandardOutput>, with one exception: if set to inherit the file descriptor used for standard output is duplicated for standard error. This setting defaults to the value set with C<DefaultStandardError> in L<systemd-system.conf(5)>, which defaults to inherit. Note that setting this parameter might result in additional dependencies to be added to the unit (see above).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TTYPath',
      {
        'description' => 'Sets the terminal device node to use if standard input, output, or error are connected to a TTY (see above). Defaults to /dev/console.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TTYReset',
      {
        'description' => 'Reset the terminal device specified with C<TTYPath> before and after execution. Defaults to C<no>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TTYVHangup',
      {
        'description' => 'Disconnect all clients which have opened the terminal device specified with C<TTYPath> before and after execution. Defaults to C<no>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TTYVTDisallocate',
      {
        'description' => 'If the terminal device specified with C<TTYPath> is a virtual console terminal, try to deallocate the TTY before and after execution. This ensures that the screen and scrollback buffer is cleared. Defaults to C<no>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SyslogIdentifier',
      {
        'description' => 'Sets the process name to prefix log lines sent to the logging system or the kernel log buffer with. If not set, defaults to the process name of the executed process. This option is only useful when C<StandardOutput> or C<StandardError> are set to syslog, journal or kmsg (or to the same settings in combination with +console).',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SyslogFacility',
      {
        'description' => 'Sets the syslog facility to use when logging to syslog. One of kern, user, mail, daemon, auth, syslog, lpr, news, uucp, cron, authpriv, ftp, local0, local1, local2, local3, local4, local5, local6 or local7. See L<syslog(3)> for details. This option is only useful when C<StandardOutput> or C<StandardError> are set to syslog. Defaults to daemon.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SyslogLevel',
      {
        'description' => 'The default syslog level to use when logging to syslog or the kernel log buffer. One of emerg, alert, crit, err, warning, notice, info, debug. See L<syslog(3)> for details. This option is only useful when C<StandardOutput> or C<StandardError> are set to syslog or kmsg. Note that individual lines output by the daemon might be prefixed with a different log level which can be used to override the default log level specified here. The interpretation of these prefixes may be disabled with C<SyslogLevelPrefix>, see below. For details, see L<sd-daemon(3)>. Defaults to info.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SyslogLevelPrefix',
      {
        'description' => 'Takes a boolean argument. If true and C<StandardOutput> or C<StandardError> are set to syslog, kmsg or journal, log lines written by the executed process that are prefixed with a log level will be passed on to syslog with this log level set but the prefix removed. If set to false, the interpretation of these prefixes is disabled and the logged lines are passed on as-is. For details about this prefixing see L<sd-daemon(3)>. Defaults to true.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'TimerSlackNSec',
      {
        'description' => 'Sets the timer slack in nanoseconds for the executed processes. The timer slack controls the accuracy of wake-ups triggered by timers. See L<prctl(2)> for more information. Note that in contrast to most other time span definitions this parameter takes an integer value in nano-seconds if no unit is specified. The usual time units are understood too.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'LimitCPU',
      {
        'description' => 'These settings set both soft and hard limits of various resources for executed processes. See L<setrlimit(2)> for details. Use the string infinity to configure no limit on a specific resource. The multiplicative suffixes K (=1024), M (=1024*1024) and so on for G, T, P and E may be used for resource limits measured in bytes (e.g. C<LimitAS>16G). For the limits referring to time values, the usual time units ms, s, min, h and so on may be used (see L<systemd.time(7)> for details). Note that if no time unit is specified for C<LimitCPU> the default unit of seconds is implied, while for C<LimitRTTIME> the default unit of microseconds is implied. Also, note that the effective granularity of the limits might influence their enforcement. For example, time limits specified for C<LimitCPU> will be rounded up implicitly to multiples of 1s.Note that most process resource limits configured with these options are per-process, and processes may fork in order to acquire a new set of resources that are accounted independently of the original process, and may thus escape limits set. Also note that C<LimitRSS> is not implemented on Linux, and setting it has no effect. Often it is advisable to prefer the resource controls listed in L<systemd.resource-control(5)> over these per-process limits, as they apply to services as a whole, may be altered dynamically at runtime, and are generally more expressive. For example, C<MemoryLimit> is a more powerful (and working) replacement for C<LimitRSS>.Limit directives and their equivalent with ulimitDirectiveulimit C<equivalentUnitLimitCPU>ulimit -C<tSecondsLimitFSIZE>ulimit -C<fBytesLimitDATA>ulimit -C<dBytesLimitSTACK>ulimit -C<sBytesLimitCORE>ulimit -C<cBytesLimitRSS>ulimit -C<mBytesLimitNOFILE>ulimit -nNumber of File C<DescriptorsLimitAS>ulimit -C<vBytesLimitNPROC>ulimit -uNumber of C<ProcessesLimitMEMLOCK>ulimit -C<lBytesLimitLOCKS>ulimit -xNumber of C<LocksLimitSIGPENDING>ulimit -iNumber of Queued C<SignalsLimitMSGQUEUE>ulimit -C<qBytesLimitNICE>ulimit -eNice C<LevelLimitRTPRIO>ulimit -rRealtime C<PriorityLimitRTTIME>No equivalentMicroseconds',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'PAMName',
      {
        'description' => 'Sets the PAM service name to set up a session as. If set, the executed process will be registered as a PAM session under the specified service name. This is only useful in conjunction with the C<User> setting. If not set, no PAM session will be opened for the executed processes. See L<pam(8)> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'CapabilityBoundingSet',
      {
        'description' => 'Controls which capabilities to include in the capability bounding set for the executed process. See L<capabilities(7)> for details. Takes a whitespace-separated list of capability names as read by L<cap_from_name(3)>, e.g. CAP_SYS_ADMIN, CAP_DAC_OVERRIDE, CAP_SYS_PTRACE. Capabilities listed will be included in the bounding set, all others are removed. If the list of capabilities is prefixed with C<~>, all but the listed capabilities will be included, the effect of the assignment inverted. Note that this option also affects the respective capabilities in the effective, permitted and inheritable capability sets, on top of what C<Capabilities> does. If this option is not used, the capability bounding set is not modified on process execution, hence no limits on the capabilities of the process are enforced. This option may appear more than once, in which case the bounding sets are merged. If the empty string is assigned to this option, the bounding set is reset to the empty capability set, and all prior settings have no effect. If set to C<~> (without any further argument), the bounding set is reset to the full set of available capabilities, also undoing any previous settings.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SecureBits',
      {
        'description' => 'Controls the secure bits set for the executed process. Takes a space-separated combination of options from the following list: keep-caps, keep-caps-locked, no-setuid-fixup, no-setuid-fixup-locked, noroot, and noroot-locked. This option may appear more than once, in which case the secure bits are ORed. If the empty string is assigned to this option, the bits are reset to 0. See L<capabilities(7)> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Capabilities',
      {
        'description' => 'Controls the L<capabilities(7)> set for the executed process. Take a capability string describing the effective, permitted and inherited capability sets as documented in L<cap_from_text(3)>. Note that these capability sets are usually influenced (and filtered) by the capabilities attached to the executed file. Due to that C<CapabilityBoundingSet> is probably a much more useful setting.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'ReadWriteDirectories',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Sets up a new file system namespace for executed processes. These options may be used to limit access a process might have to the main file system hierarchy. Each setting takes a space-separated list of absolute directory paths. Directories listed in C<ReadWriteDirectories> are accessible from within the namespace with the same access rights as from outside. Directories listed in C<ReadOnlyDirectories> are accessible for reading only, writing will be refused even if the usual file access controls would permit this. Directories listed in C<InaccessibleDirectories> will be made inaccessible for processes inside the namespace. Note that restricting access with these options does not extend to submounts of a directory that are created later on. These options may be specified more than once, in which case all directories listed will have limited access from within the namespace. If the empty string is assigned to this option, the specific list is reset, and all prior assignments have no effect.Paths in C<ReadOnlyDirectories> and C<InaccessibleDirectories> may be prefixed with C<->, in which case they will be ignored when they do not exist. Note that using this setting will disconnect propagation of mounts from the service to the host (propagation in the opposite direction continues to work). This means that this setting may not be used for services which shall be able to install mount points in the main mount namespace.',
        'type' => 'list'
      },
      'PrivateTmp',
      {
        'description' => 'Takes a boolean argument. If true, sets up a new file system namespace for the executed processes and mounts private /tmp and /var/tmp directories inside it that is not shared by processes outside of the namespace. This is useful to secure access to temporary files of the process, but makes sharing between processes via /tmp or /var/tmp impossible. If this is enabled, all temporary files created by a service in these directories will be removed after the service is stopped. Defaults to false. It is possible to run two or more units within the same private /tmp and /var/tmp namespace by using the C<JoinsNamespaceOf> directive, see L<systemd.unit(5)> for details. Note that using this setting will disconnect propagation of mounts from the service to the host (propagation in the opposite direction continues to work). This means that this setting may not be used for services which shall be able to install mount points in the main mount namespace.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'PrivateDevices',
      {
        'description' => 'Takes a boolean argument. If true, sets up a new /dev namespace for the executed processes and only adds API pseudo devices such as /dev/null, /dev/zero or /dev/random (as well as the pseudo TTY subsystem) to it, but no physical devices such as /dev/sda. This is useful to securely turn off physical device access by the executed process. Defaults to false. Enabling this option will also remove CAP_MKNOD from the capability bounding set for the unit (see above), and set C<DevicePolicy>closed (see L<systemd.resource-control(5)> for details). Note that using this setting will disconnect propagation of mounts from the service to the host (propagation in the opposite direction continues to work). This means that this setting may not be used for services which shall be able to install mount points in the main mount namespace.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'PrivateNetwork',
      {
        'description' => 'Takes a boolean argument. If true, sets up a new network namespace for the executed processes and configures only the loopback network device C<lo> inside it. No other network devices will be available to the executed process. This is useful to securely turn off network access by the executed process. Defaults to false. It is possible to run two or more units within the same private network namespace by using the C<JoinsNamespaceOf> directive, see L<systemd.unit(5)> for details. Note that this option will disconnect all socket families from the host, this includes AF_NETLINK and AF_UNIX. The latter has the effect that AF_UNIX sockets in the abstract socket namespace will become unavailable to the processes (however, those located in the file system will continue to be accessible).',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'ProtectSystem',
      {
        'description' => 'Takes a boolean argument or C<full>. If true, mounts the /usr and /boot directories read-only for processes invoked by this unit. If set to C<full>, the /etc directory is mounted read-only, too. This setting ensures that any modification of the vendor-supplied operating system (and optionally its configuration) is prohibited for the service. It is recommended to enable this setting for all long-running services, unless they are involved with system updates or need to modify the operating system in other ways. Note however that processes retaining the CAP_SYS_ADMIN capability can undo the effect of this setting. This setting is hence particularly useful for daemons which have this capability removed, for example with C<CapabilityBoundingSet>. Defaults to off.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'ProtectHome',
      {
        'description' => 'Takes a boolean argument or C<read-only>. If true, the directories /home, /root and /run/user are made inaccessible and empty for processes invoked by this unit. If set to C<read-only>, the three directories are made read-only instead. It is recommended to enable this setting for all long-running services (in particular network-facing ones), to ensure they cannot get access to private user data, unless the services actually require access to the user\'s private data. Note however that processes retaining the CAP_SYS_ADMIN capability can undo the effect of this setting. This setting is hence particularly useful for daemons which have this capability removed, for example with C<CapabilityBoundingSet>. Defaults to off.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'MountFlags',
      {
        'description' => 'Takes a mount propagation flag: shared, slave or private, which control whether mounts in the file system namespace set up for this unit\'s processes will receive or propagate mounts or unmounts. See L<mount(2)> for details. Defaults to shared. Use shared to ensure that mounts and unmounts are propagated from the host to the container and vice versa. Use slave to run processes so that none of their mounts and unmounts will propagate to the host. Use private to also ensure that no mounts and unmounts from the host will propagate into the unit processes\' namespace. Note that slave means that file systems mounted on the host might stay mounted continuously in the unit\'s namespace, and thus keep the device busy. Note that the file system namespace related options (C<PrivateTmp>, C<PrivateDevices>, C<ProtectSystem>, C<ProtectHome>, C<ReadOnlyDirectories>, C<InaccessibleDirectories> and C<ReadWriteDirectories>) require that mount and unmount propagation from the unit\'s file system namespace is disabled, and hence downgrade shared to slave.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'UtmpIdentifier',
      {
        'description' => 'Takes a four character identifier string for an L<utmp(5)> and wtmp entry for this service. This should only be set for services such as getty implementations (such as L<agetty(8)>) where utmp/wtmp entries must be created and cleared before and after execution, or for services that shall be executed as if they were run by a getty process (see below). If the configured string is longer than four characters, it is truncated and the terminal four characters are used. This setting interprets %I style string replacements. This setting is unset by default, i.e. no utmp/wtmp entries are created or cleaned up for this service.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'UtmpMode',
      {
        'description' => 'Takes one of C<init>, C<login> or C<user>. If C<UtmpIdentifier> is set, controls which type of L<utmp(5)>/wtmp entries for this service are generated. This setting has no effect unless C<UtmpIdentifier> is set too. If C<init> is set, only an INIT_PROCESS entry is generated and the invoked process must implement a getty-compatible utmp/wtmp logic. If C<login> is set, first an INIT_PROCESS entry, followed by a LOGIN_PROCESS entry is generated. In this case, the invoked process must implement a L<login(1)>-compatible utmp/wtmp logic. If C<user> is set, first an INIT_PROCESS entry, then a LOGIN_PROCESS entry and finally a USER_PROCESS entry is generated. In this case, the invoked process may be any process that is suitable to be run as session leader. Defaults to C<init>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SELinuxContext',
      {
        'description' => 'Set the SELinux security context of the executed process. If set, this will override the automated domain transition. However, the policy still needs to authorize the transition. This directive is ignored if SELinux is disabled. If prefixed by C<->, all errors will be ignored. See L<setexeccon(3)> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'AppArmorProfile',
      {
        'description' => 'Takes a profile name as argument. The process executed by the unit will switch to this profile when started. Profiles must already be loaded in the kernel, or the unit will fail. This result in a non operation if AppArmor is not enabled. If prefixed by C<->, all errors will be ignored.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SmackProcessLabel',
      {
        'description' => 'Takes a SMACK64 security label as argument. The process executed by the unit will be started under this label and SMACK will decide whether the process is allowed to run or not, based on it. The process will continue to run under the label specified here unless the executable has its own SMACK64EXEC label, in which case the process will transition to run under that label. When not specified, the label that systemd is running under is used. This directive is ignored if SMACK is disabled.The value may be prefixed by C<->, in which case all errors will be ignored. An empty value may be specified to unset previous assignments.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'IgnoreSIGPIPE',
      {
        'description' => 'Takes a boolean argument. If true, causes SIGPIPE to be ignored in the executed process. Defaults to true because SIGPIPE generally is useful only in shell pipelines.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'NoNewPrivileges',
      {
        'description' => 'Takes a boolean argument. If true, ensures that the service process and all its children can never gain new privileges. This option is more powerful than the respective secure bits flags (see above), as it also prohibits UID changes of any kind. This is the simplest, most effective way to ensure that a process and its children can never elevate privileges again.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'SystemCallFilter',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Takes a space-separated list of system call names. If this setting is used, all system calls executed by the unit processes except for the listed ones will result in immediate process termination with the SIGSYS signal (whitelisting). If the first character of the list is C<~>, the effect is inverted: only the listed system calls will result in immediate process termination (blacklisting). If running in user mode and this option is used, C<NoNewPrivileges>yes is implied. This feature makes use of the Secure Computing Mode 2 interfaces of the kernel (\'seccomp filtering\') and is useful for enforcing a minimal sandboxing environment. Note that the execve, rt_sigreturn, sigreturn, exit_group, exit system calls are implicitly whitelisted and do not need to be listed explicitly. This option may be specified more than once, in which case the filter masks are merged. If the empty string is assigned, the filter is reset, all prior assignments will have no effect.If you specify both types of this option (i.e. whitelisting and blacklisting), the first encountered will take precedence and will dictate the default action (termination or approval of a system call). Then the next occurrences of this option will add or delete the listed system calls from the set of the filtered system calls, depending of its type and the default action. (For example, if you have started with a whitelisting of read and write, and right after it add a blacklisting of write, then write will be removed from the set.)',
        'type' => 'list'
      },
      'SystemCallErrorNumber',
      {
        'description' => 'Takes an C<errno> error number name to return when the system call filter configured with C<SystemCallFilter> is triggered, instead of terminating the process immediately. Takes an error name such as EPERM, EACCES or EUCLEAN. When this setting is not used, or when the empty string is assigned, the process will be terminated immediately when the filter is triggered.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'SystemCallArchitectures',
      {
        'description' => 'Takes a space-separated list of architecture identifiers to include in the system call filter. The known architecture identifiers are x86, x86-64, x32, arm as well as the special identifier native. Only system calls of the specified architectures will be permitted to processes of this unit. This is an effective way to disable compatibility with non-native architectures for processes, for example to prohibit execution of 32-bit x86 binaries on 64-bit x86-64 systems. The special native identifier implicitly maps to the native architecture of the system (or more strictly: to the architecture the system manager is compiled for). If running in user mode and this option is used, C<NoNewPrivileges>yes is implied. Note that setting this option to a non-empty list implies that native is included too. By default, this option is set to the empty list, i.e. no architecture system call filtering is applied.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RestrictAddressFamilies',
      {
        'description' => 'Restricts the set of socket address families accessible to the processes of this unit. Takes a space-separated list of address family names to whitelist, such as AF_UNIX, AF_INET or AF_INET6. When prefixed with ~ the listed address families will be applied as blacklist, otherwise as whitelist. Note that this restricts access to the L<socket(2)> system call only. Sockets passed into the process by other means (for example, by using socket activation with socket units, see L<systemd.socket(5)>) are unaffected. Also, sockets created with socketpair() (which creates connected AF_UNIX sockets only) are unaffected. Note that this option has no effect on 32-bit x86 and is ignored (but works correctly on x86-64). If running in user mode and this option is used, C<NoNewPrivileges>yes is implied. By default, no restriction applies, all address families are accessible to processes. If assigned the empty string, any previous list changes are undone.Use this option to limit exposure of processes to remote systems, in particular via exotic network protocols. Note that in most cases, the local AF_UNIX address family should be included in the configured whitelist as it is frequently used for local communication, including for L<syslog(2)> logging.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Personality',
      {
        'description' => 'Controls which kernel architecture L<uname(2)> shall report, when invoked by unit processes. Takes one of x86 and x86-64. This is useful when running 32-bit services on a 64-bit host system. If not specified, the personality is left unmodified and thus reflects the personality of the host system\'s kernel.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'RuntimeDirectory',
      {
        'description' => 'Takes a list of directory names. If set, one or more directories by the specified names will be created below /run (for system services) or below $XDG_RUNTIME_DIR (for user services) when the unit is started, and removed when the unit is stopped. The directories will have the access mode specified in C<RuntimeDirectoryMode>, and will be owned by the user and group specified in C<User> and C<Group>. Use this to manage one or more runtime directories of the unit and bind their lifetime to the daemon runtime. The specified directory names must be relative, and may not include a C</>, i.e. must refer to simple directories to create or remove. This is particularly useful for unprivileged daemons that cannot create runtime directories in /run due to lack of privileges, and to make sure the runtime directory is cleaned up automatically after use. For runtime directories that require more complex or different configuration or lifetime guarantees, please consider using L<tmpfiles.d(5)>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'generated_by' => 'systemd parse-man.pl',
    'name' => 'Systemd::Common::Exec'
  }
]
;

