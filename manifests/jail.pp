#
define jails::jail (
  $disable               = false,
  $service_autorestart   = true,
  $template              = '',

  $jid                   = '',
  $path                  = '',

  $ip4                   = '',
  $ip4_addr              = '',
  $ip4_saddrsel          = '',
  $ip6                   = '',
  $ip6_addr              = '',
  $ip6_saddrsel          = '',
  $interface             = '',
  $vnet                  = '',
  $vnet_interface        = '',
  $host_hostname         = '',
  $host_domainname       = '',
  $host_hostuuid         = '',
  $host_hostid           = '',
  $ip_hostname           = '',
  $host                  = '',
  $securelevel           = '',
  $devfs_ruleset         = '',
  $children_max          = '',
  $children_cur          = '',
  $enforce_statfs        = '',
  $persist               = '',

  $allow_set_hostname    = '',
  $allow_sysvipc         = '',
  $allow_raw_sockets     = '',
  $allow_chflags         = '',
  $allow_mount           = '',
  $allow_mount_devfs     = '',
  $allow_mount_nullfs    = '',
  $allow_mount_procfs    = '',
  $allow_mount_tmpfs     = '',
  $allow_mount_zfs       = '',
  $allow_quotas          = '',
  $allow_socket_af       = '',
  $allow_dying           = '',

  $exec_prestart         = '',
  $exec_start            = '',
  $exec_poststart        = '',
  $exec_prestop          = '',
  $exec_stop             = '',
  $exec_poststop         = '',
  $exec_clean            = '',
  $exec_jail_user        = '',
  $exec_system_jail_user = '',
  $exec_system_user      = '',
  $exec_timeout          = '',
  $exec_consolelog       = '',
  $exec_fib              = '',
  $stop_timeout          = '',

  $mount                 = '',
  $mount_fstab           = '',
  $mount_devfs           = '',
  $mount_fdescfs         = '',

  $depend                = '',
) {
  include ::jails

  $bool_disable=any2bool($disable)
  $bool_service_autorestart=any2bool($service_autorestart)

  $manage_service_ensure = $bool_disable ? {
    true    => 'stopped',
    default => 'running',
  }

  $manage_service_autorestart = $bool_service_autorestart ? {
    true     => "Service[jail-${name}]",
    default  => undef,
  }

  $manage_file_content = $template ? {
    ''      => template($jails::template),
    default => template($template),
  }

  $manage_file_ensure = $bool_disable ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_file_path = "${jails::config_dir}/${name}.conf"

  file { "jail.conf-${name}":
    ensure  => $manage_file_ensure,
    path    => $manage_file_path,
    owner   => $jails::config_file_owner,
    group   => $jails::config_file_group,
    mode    => $jails::config_file_mode,
    content => $manage_file_content,
    notify  => $manage_service_autorestart,
  }

  service { "jail-${name}":
    ensure    => $manage_service_ensure,
    hasstatus => false,
    start     => "/usr/sbin/jail -f ${manage_file_path} -c ${name}",
    restart   => "/usr/sbin/jail -f ${manage_file_path} -rc ${name}",
    stop      => "/usr/sbin/jail -f ${manage_file_path} -r ${name}",
    status    => "/usr/sbin/jls -j ${name}",
    require   => File["jail.conf-${name}"],
  }
}
