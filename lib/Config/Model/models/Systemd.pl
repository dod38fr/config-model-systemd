[
  {
    'element' => [
      'service',
      {
        'cargo' => {
          'config_class_name' => 'Systemd::Service',
          'type' => 'node'
        },
        'index_type' => 'string',
        'type' => 'hash'
      },
      'socket',
      {
        'cargo' => {
          'config_class_name' => 'Systemd::Socket',
          'type' => 'node'
        },
        'index_type' => 'string',
        'type' => 'hash'
      },
      'timer',
      {
        'cargo' => {
          'config_class_name' => 'Systemd::Timer',
          'type' => 'node'
        },
        'index_type' => 'string',
        'type' => 'hash'
      }
    ],
    'generated_by' => 'parse-man.pl from systemd doc',
    'name' => 'Systemd',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'Systemd'
    }
  }
]
;

