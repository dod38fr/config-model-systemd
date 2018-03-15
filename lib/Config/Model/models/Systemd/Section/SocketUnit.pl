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
      'FailureAction',
      {
        'description' => 'Configure the action to take when the unit stops and enters a failed state or inactive
state. Takes the same values as the setting C<StartLimitAction> setting and executes the same
actions. Both options default to C<none>.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'include' => [
      'Systemd::Section::Unit'
    ],
    'name' => 'Systemd::Section::SocketUnit'
  }
]
;

