# == Class: diamond::install
#
# Class to install Diamond from package.
#
class diamond::install {

if $diamond::install_method == git {
    
    $strippedversion  = regsubst( $diamond::version, '-[^-]*$', '' )
    $version  = regsubst( $strippedversion, '\-', '.' )

    #notify {"version is $version": }

} else {
 
    $version  = $diamond::version

}

    case $::osfamily {
      Redhat: {
        package {'diamond':
          ensure   => present,
          provider => rpm,
          source   => "/tmp/Diamond-v${diamond::version}/dist/diamond-${diamond::version}.0-0.noarch.rpm"
        }
      }
      Debian: {
        package {'diamond':
          ensure   => present,
          provider => dpkg,
          source   => "/tmp/Diamond-v${diamond::version}/build/diamond_${version}_all.deb"
        }
      }
      default: { fail('Unrecognized operating system') }
    }

}

