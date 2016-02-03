[
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'class_description' => 'common install section',
    'include' => [
      'Systemd::Common::ResourceControl',
      'Systemd::Common::Exec',
      'Systemd::Common::Kill'
    ],
    'name' => 'Systemd::Section::Service'
  }
]
;

