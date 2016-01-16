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
      }
    ],
    'name' => 'Systemd',
    'read_config' => [
      {
        'backend' => 'Systemd'
      }
    ]
  }
]
;
