# == Class: diamond::install
#
# Class to install Diamond from package.
#
class diamond::install {

    case $::osfamily {
      Redhat: {
        package {'diamond':
          ensure   => present,
          provider => rpm,
          source   => "/tmp/Diamond-${diamond::version}/dist/diamond-${diamond::version}.0-0.noarch.rpm"
        }
      }
      Debian: {
        package {'diamond':
          ensure   => present,
          provider => dpkg,
          source   => "/tmp/Diamond-${diamond::version}/build/diamond_${diamond::version}.0_all.deb"
        }
      }
      default: { fail('Unrecognized operating system') }
    }

}

