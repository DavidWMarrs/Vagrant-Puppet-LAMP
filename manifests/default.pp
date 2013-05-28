# It would be preferable if we only had to run apt-get update when a new
# package needed to be installed
exec { "apt-update":
  command => "/usr/bin/apt-get update",
}

Exec['apt-update'] -> Package <| |>

include apache

apache::vhost {'vagrant':
  vhost_name => '*',
  port => '80',
  docroot => '/var/www/',
  override => 'All'
}

a2mod { 'rewrite' :
  ensure => present,
  notify => Service['httpd']
}

class {'apache::mod::php': 
  notify => Service['httpd']
}

include mysql

class { 'mysql::server':
  config_hash => { 
    'root_password' => 'Password01',
    'bind_address' => false
  }
}

database_user { 'root@10.0.2.2':
  password_hash => mysql_password('Password01')
}

database_grant { 'root@10.0.2.2' :
  privileges => ['all']
}

package { 'php5-mysql' :
  ensure => installed,
  require => Class['apache::mod::php'],
  notify => Service['httpd'],
}

# The following packages and exec are required for Drupal 7
package { 'php5-gd' :
  ensure => installed,
  require => Class['apache::mod::php'],
  notify => Service['httpd'],
}

package { 'php-pear' :
  ensure => installed,
  require => Class['apache::mod::php'],
}

package { 'php5-dev' :
  ensure => installed,
  require => Class['apache::mod::php'],
}

package { 'make' :
  ensure => installed,
}

exec { "pecl-uploadprogress":
  command => "/usr/bin/pecl install uploadprogress",
  require => [Package['php-pear'],Package['php5-dev'],Package['make']],
  creates => "/usr/share/doc/php5-common/PEAR/uploadprogress"
}

# The new file for php.ini changes error reporting settings for a development
# environment and adds the uploadprogress pecl extension (see below) 
file {'/etc/php5/apache2/php.ini':
  ensure => file,
  require => Exec['pecl-uploadprogress'],
  content => template('/vagrant/templates/php.ini.erb'),
  notify => Service['httpd']
}
