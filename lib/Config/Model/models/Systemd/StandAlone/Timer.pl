use strict;
use warnings;

return [
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn' => 'Unexpected systemd parameter. Please contact cme author to update systemd model.'
      }
    ],
    'element' => [
      'Timer',
      {
        'config_class_name' => 'Systemd::Section::Timer',
        'type' => 'node'
      },
      'Unit',
      {
        'config_class_name' => 'Systemd::Section::TimerUnit',
        'type' => 'node'
      },
      'Install',
      {
        'config_class_name' => 'Systemd::Section::Install',
        'type' => 'node'
      }
    ],
    'generated_by' => 'parse-man.pl from systemd doc',
    'name' => 'Systemd::StandAlone::Timer',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Systemd::Unit'
    }
  }
]
;

