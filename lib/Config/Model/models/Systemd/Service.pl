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
      'Service',
      {
        'config_class_name' => 'Systemd::Section::Service',
        'type' => 'node'
      },
      'Install',
      {
        'config_class_name' => 'Systemd::Section::Install',
        'type' => 'node'
      }
    ],
    'name' => 'Systemd::Service',
    'read_config' => [
      {
        'auto_create' => '1',
        'auto_delete' => '1',
        'backend' => 'Systemd::Unit',
        'file' => '&index.service'
      }
    ]
  }
]
;

