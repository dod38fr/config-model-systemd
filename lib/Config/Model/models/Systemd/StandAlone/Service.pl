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
      'Service',
      {
        'config_class_name' => 'Systemd::Section::Service',
        'type' => 'node'
      },
      'Unit',
      {
        'config_class_name' => 'Systemd::Section::ServiceUnit',
        'type' => 'node'
      },
      'Install',
      {
        'config_class_name' => 'Systemd::Section::Install',
        'type' => 'node'
      }
    ],
    'generated_by' => 'parse-man.pl from systemd doc',
    'name' => 'Systemd::StandAlone::Service',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Systemd::Unit'
    }
  }
]
;

