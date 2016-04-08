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
      'Socket',
      {
        'config_class_name' => 'Systemd::Section::Socket',
        'follow' => {
          'disable' => '- disable'
        },
        'rules' => [
          '$disable',
          {
            'level' => 'hidden'
          }
        ],
        'type' => 'warped_node'
      }
    ],
    'include' => [
      'Systemd::CommonElements'
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

