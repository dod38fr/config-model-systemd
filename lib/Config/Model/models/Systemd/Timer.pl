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
      'Timer',
      {
        'config_class_name' => 'Systemd::Section::Timer',
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
    'name' => 'Systemd::Timer',
    'read_config' => [
      {
        'auto_create' => '1',
        'auto_delete' => '1',
        'backend' => 'Systemd::Unit',
        'file' => '&index.timer'
      }
    ]
  }
]
;

