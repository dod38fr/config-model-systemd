[
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
      'Unit',
      {
        'config_class_name' => 'Systemd::Section::Unit',
        'type' => 'node'
      },
      'Socket',
      {
        'config_class_name' => 'Systemd::Section::Socket',
        'type' => 'node'
      },
      'Install',
      {
        'config_class_name' => 'Systemd::Section::Install',
        'type' => 'node'
      }
    ],
    'name' => 'Systemd::Socket',
    'read_config' => [
      {
        'auto_create' => '1',
        'backend' => 'IniFile',
        'file' => '&index.socket'
      }
    ]
  }
]
;

