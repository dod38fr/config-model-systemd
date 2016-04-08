[
  {
    'element' => [
      'disable',
      {
        'default' => '0',
        'description' => 'When true, cme will disable a configuration file supplied by the vendor by placing place a symlink to
/dev/null with the same filename as the vendor configuration file.
See L<systemd-system.conf> for details.',
        'summary' => 'disable configuration file supplied by the vendor',
        'type' => 'leaf',
        'value_type' => 'boolean'
      },
      'Unit',
      {
        'config_class_name' => 'Systemd::Section::Unit',
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
      },
      'Install',
      {
        'config_class_name' => 'Systemd::Section::Install',
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
    'name' => 'Systemd::CommonElements'
  }
]
;

