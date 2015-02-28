# == Class: diamond
#
# Installation
#
class diamond::archive {

  if $diamond::install_method == 'archive' {

    archive { "Diamond-${diamond::version}":
      ensure           => present,
      checksum         => false,
      target           => '/tmp',
      follow_redirects => true,
      url              => "https://github.com/python-diamond/Diamond/archive/v${diamond::version}.tar.gz",
    }

  }

}
