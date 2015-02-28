# == Class: diamond::config
#
# The configuration of the Diamond daemon
#
class diamond::config {
  $interval         = $diamond::interval
  $graphite_host    = $diamond::graphite_host
  $graphite_handler = $diamond::graphite_handler
  $riemann_host     = $diamond::riemann_host
  $librato_user     = $diamond::librato_user
  $librato_apikey   = $diamond::librato_apikey
  $path_prefix      = $diamond::path_prefix
  $path_suffix      = $diamond::path_suffix
  $handlers_path    = $diamond::handlers_path
  $rotate_days      = $diamond::rotate_days
  file { '/etc/diamond/diamond.conf':
    ensure  => present,
    content => template('diamond/etc/diamond/diamond.conf.erb'),
  }

  file { '/etc/diamond/collectors':
    ensure  => directory,
    owner   => root,
    group   => root,
    purge   => $diamond::purge_collectors,
    recurse => true,
  }

  #file { '/usr/share/diamond/collectors/weblogic':
  #  ensure  => directory,
  #  owner   => root,
  #  group   => root,
  #  require => Package['diamond'],
  #}

  #file { '/usr/share/diamond/collectors/weblogic/weblogic.py':
  #  ensure => file,
  #  owner  => root,
  #  group  => root,
  #  source => "puppet:///modules/diamond/usr/share/diamond/collectors/weblogic/weblogic.py",
  #}

  if $diamond::librato_user and $diamond::librato_apikey {
    ensure_packages(['python-pip'])
    ensure_resource('package', 'librato-metrics', {'ensure' => 'present', 'provider' => pip, 'before' => Package['python-pip']})
  }

  if $diamond::riemann_host {
    ensure_packages(['python-pip'])
    ensure_resource('package', 'bernhard', {'ensure' => 'present', 'provider' => pip, 'before' => Package['python-pip']})
  }

}
