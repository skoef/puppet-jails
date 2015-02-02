# = Class: jails
#
# Main class for managing FreeBSD Jails
# Sets up the environment to create jails::jail
# resources in.
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, jails class will automatically "include $my_class"
#
# [*config_dir*]
#   Path to jails configs, to override the config_dir from jails::params.
#
# [*jails*]
#   Hash containing jails::jail resource definitions.
#
# [*defaults*]
#   Hash containing default settings being applied on all $jails.
#   This overrides the hardcoded hash from jails::params.
#
# == Author
#   Reinier Schoof <reinier@skoef.nl>
#
class jails (
  $my_class   = $jails::params::my_class,
  $config_dir = $jails::params::config_dir,
  $jails      = $jails::params::jails,
  $defaults   = $jails::params::defaults,
  $template   = $jails::params::template,
) inherits jails::params {

  if $my_class != '' {
    include $my_class
  }

  file { 'jail.d':
    ensure => directory,
    path   => $jails::config_dir,
  }

  # create defined jails
  create_resources('jails::jail', $jails, $defaults)
}
