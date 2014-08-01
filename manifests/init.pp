#
class jails (
  $config_dir = $jails::params::config_dir,
  $jails      = {},
  $defaults   = $jails::params::defaults,
) inherits jails::params {

  file { 'jail.d':
    ensure => directory,
    path   => $jails::config_dir,
  }

  # create defined jails
  create_resources('jails::jail', $jails, $defaults)
}
