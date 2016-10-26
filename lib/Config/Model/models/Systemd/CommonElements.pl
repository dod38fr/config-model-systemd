[
  {
    'element' => [
      'disable',
      {
        'description' => 'When true, cme will disable a configuration file supplied by the vendor by placing place a symlink to
/dev/null with the same filename as the vendor configuration file.
See L<systemd-system.conf> for details.',
        'summary' => 'disable configuration file supplied by the vendor',
        'type' => 'leaf',
        'upstream_default' => '0',
        'value_type' => 'boolean'
      },
      'Unit',
      {
        'config_class_name' => 'Systemd::Section::Unit',
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
      },
      'Install',
      {
        'config_class_name' => 'Systemd::Section::Install',
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
    'name' => 'Systemd::CommonElements'
  }
]
;

