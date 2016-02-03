[
  {
    'class_description' => 'Unit configuration files for services, slices, scopes, sockets, mount points, and swap devices share a subset of configuration options for resource control of spawned processes. Internally, this relies on the Control Groups kernel concept for organizing processes in a hierarchical tree of named groups for the purpose of resource management.

This man page lists the configuration options shared by those six unit types. See L<systemd.unit(5)> for the common options of all unit configuration files, and L<systemd.slice(5)>, L<systemd.scope(5)>, L<systemd.service(5)>, L<systemd.socket(5)>, L<systemd.mount(5)>, and L<systemd.swap(5)> for more information on the specific unit configuration files. The resource control configuration options are configured in the [Slice], [Scope], [Service], [Socket], [Mount], or [Swap] sections, depending on the unit type.

See the New Control Group Interfaces for an introduction on how to make use of resource control APIs from programs.',
    'element' => [
      'CPUAccounting',
      {
        'description' => 'Turn on CPU usage accounting for this unit. Takes a boolean argument. Note that turning on CPU accounting for one unit will also implicitly turn it on for all units contained in the same slice and for all its parent slices and the units contained therein. The system default for this setting may be controlled with C<DefaultCPUAccounting> in L<systemd-system.conf(5)>.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'CPUShares',
      {
        'description' => 'Assign the specified CPU time share weight to the processes executed. These options take an integer value and control the C<cpu.shares> control group attribute. The allowed range is 2 to 262144. Defaults to 1024. For details about this control group attribute, see sched-design-CFS.txt. The available CPU time is split up among all units within one slice relative to their CPU time share weight.While C<StartupCPUShares> only applies to the startup phase of the system, C<CPUShares> applies to normal runtime of the system, and if the former is not set also to the startup phase. Using C<StartupCPUShares> allows prioritizing specific services at boot-up differently than during normal runtime.These options imply C<C<CPUAccounting>true>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'CPUQuota',
      {
        'description' => 'Assign the specified CPU time quota to the processes executed. Takes a percentage value, suffixed with "%". The percentage specifies how much CPU time the unit shall get at maximum, relative to the total CPU time available on one CPU. Use values > 100% for allotting CPU time on more than one CPU. This controls the C<cpu.cfs_quota_us> control group attribute. For details about this control group attribute, see sched-design-CFS.txt.Example: C<CPUQuota>20% ensures that the executed processes will never get more than 20% CPU time on one CPU.Implies C<C<CPUAccounting>true>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'MemoryAccounting',
      {
        'description' => 'Turn on process and kernel memory accounting for this unit. Takes a boolean argument. Note that turning on memory accounting for one unit will also implicitly turn it on for all units contained in the same slice and for all its parent slices and the units contained therein. The system default for this setting may be controlled with C<DefaultMemoryAccounting> in L<systemd-system.conf(5)>.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'MemoryLimit',
      {
        'description' => 'Specify the limit on maximum memory usage of the executed processes. The limit specifies how much process and kernel memory can be used by tasks in this unit. Takes a memory size in bytes. If the value is suffixed with K, M, G or T, the specified memory size is parsed as Kilobytes, Megabytes, Gigabytes, or Terabytes (with the base 1024), respectively. If assigned the special value C<infinity>, no memory limit is applied. This controls the C<memory.limit_in_bytes> control group attribute. For details about this control group attribute, see memory.txt.Implies C<C<MemoryAccounting>true>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'TasksAccounting',
      {
        'description' => 'Turn on task accounting for this unit. Takes a boolean argument. If enabled, the system manager will keep track of the number of tasks in the unit. The number of tasks accounted this way includes both kernel threads and userspace processes, with each thread counting individually. Note that turning on tasks accounting for one unit will also implicitly turn it on for all units contained in the same slice and for all its parent slices and the units contained therein. The system default for this setting may be controlled with C<DefaultTasksAccounting> in L<systemd-system.conf(5)>.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'TasksMax',
      {
        'description' => 'Specify the maximum number of tasks that may be created in the unit. This ensures that the number of tasks accounted for the unit (see above) stays below a specific limit. If assigned the special value C<infinity>, no tasks limit is applied. This controls the C<pids.max> control group attribute. For details about this control group attribute, see pids.txt.Implies C<C<TasksAccounting>true>. The system default for this setting may be controlled with C<DefaultTasksMax> in L<systemd-system.conf(5)>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'BlockIOAccounting',
      {
        'description' => 'Turn on Block I/O accounting for this unit. Takes a boolean argument. Note that turning on block I/O accounting for one unit will also implicitly turn it on for all units contained in the same slice and all for its parent slices and the units contained therein. The system default for this setting may be controlled with C<DefaultBlockIOAccounting> in L<systemd-system.conf(5)>.',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'BlockIOWeight',
      {
        'description' => 'Set the default overall block I/O weight for the executed processes. Takes a single weight value (between 10 and 1000) to set the default block I/O weight. This controls the C<blkio.weight> control group attribute, which defaults to 500. For details about this control group attribute, see blkio-controller.txt. The available I/O bandwidth is split up among all units within one slice relative to their block I/O weight.While C<StartupBlockIOWeight> only applies to the startup phase of the system, C<BlockIOWeight> applies to the later runtime of the system, and if the former is not set also to the startup phase. This allows prioritizing specific services at boot-up differently than during runtime.Implies C<C<BlockIOAccounting>true>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'BlockIODeviceWeight',
      {
        'description' => 'Set the per-device overall block I/O weight for the executed processes. Takes a space-separated pair of a file path and a weight value to specify the device specific weight value, between 10 and 1000. (Example: "/dev/sda 500"). The file path may be specified as path to a block device node or as any other file, in which case the backing block device of the file system of the file is determined. This controls the C<blkio.weight_device> control group attribute, which defaults to 1000. Use this option multiple times to set weights for multiple devices. For details about this control group attribute, see blkio-controller.txt.Implies C<C<BlockIOAccounting>true>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'BlockIOReadBandwidth',
      {
        'description' => 'Set the per-device overall block I/O bandwidth limit for the executed processes. Takes a space-separated pair of a file path and a bandwidth value (in bytes per second) to specify the device specific bandwidth. The file path may be a path to a block device node, or as any other file in which case the backing block device of the file system of the file is used. If the bandwidth is suffixed with K, M, G, or T, the specified bandwidth is parsed as Kilobytes, Megabytes, Gigabytes, or Terabytes, respectively, to the base of 1000. (Example: "/dev/disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0 5M"). This controls the C<blkio.read_bps_device> and C<blkio.write_bps_device> control group attributes. Use this option multiple times to set bandwidth limits for multiple devices. For details about these control group attributes, see blkio-controller.txt. Implies C<C<BlockIOAccounting>true>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'DeviceAllow',
      {
        'description' => 'Control access to specific device nodes by the executed processes. Takes two space-separated strings: a device node specifier followed by a combination of r, w, m to control reading, writing, or creation of the specific device node(s) by the unit (mknod), respectively. This controls the C<devices.allow> and C<devices.deny> control group attributes. For details about these control group attributes, see devices.txt.The device node specifier is either a path to a device node in the file system, starting with /dev/, or a string starting with either C<char-> or C<block-> followed by a device group name, as listed in /proc/devices. The latter is useful to whitelist all current and future devices belonging to a specific device group at once. The device group is matched according to file name globbing rules, you may hence use the C<*> and C<?> wildcards. Examples: /dev/sda5 is a path to a device node, referring to an ATA or SCSI block device. C<char-pts> and C<char-alsa> are specifiers for all pseudo TTYs and all ALSA sound devices, respectively. C<char-cpu/*> is a specifier matching all CPU related device groups.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'DevicePolicy',
      {
        'description' => 'Control the policy for allowing device access: strictmeans to only allow types of access that are explicitly specified.closedin addition, allows access to standard pseudo devices including /dev/null, /dev/zero, /dev/full, /dev/random, and /dev/urandom. auto in addition, allows access to all devices if no explicit C<DeviceAllow> is present. This is the default.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'NetClass',
      {
        'description' => 'Configures a network class number to assign to the unit. This value will be set to the C<net_cls.class_id> property of the C<net_cls> cgroup of the unit. The directive accepts a numerical value (for fixed number assignment) and the keyword C<auto> (for dynamic allocation). Network traffic of all processes inside the unit will have the network class ID assigned by the kernel. Also see the kernel docs for net_cls controller and L<systemd.resource-control(5)>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Slice',
      {
        'description' => 'The name of the slice unit to place the unit in. Defaults to system.slice for all non-instantiated units of all unit types (except for slice units themselves see below). Instance units are by default placed in a subslice of system.slice that is named after the template name.This option may be used to arrange systemd units in a hierarchy of slices each of which might have resource settings applied.For units of type slice, the only accepted value for this setting is the parent slice. Since the name of a slice unit implies the parent slice, it is hence redundant to ever set this parameter directly for slice units.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Delegate',
      {
        'description' => 'Turns on delegation of further resource control partitioning to processes of the unit. For unprivileged services (i.e. those using the C<User> setting), this allows processes to create a subhierarchy beneath its control group path. For privileged services and scopes, this ensures the processes will have all control group controllers enabled.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'name' => 'Systemd::Common::ResourceControl'
  }
]
;

