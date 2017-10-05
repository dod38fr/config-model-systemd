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
        'type' => 'warped_node',
        'warp' => {
          'follow' => {
            'disable' => '- disable'
          },
          'rules' => [
            '$disable',
            {
              'level' => 'hidden'
            }
          ]
        }
      }
    ],
    'generated_by' => 'parse-man.pl from systemd doc',
    'include' => [
      'Systemd::CommonElements'
    ],
    'name' => 'Systemd::Socket',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Systemd::Unit',
      'file' => '&index.socket'
    }
  }
]
;

