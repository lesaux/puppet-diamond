# == Class: diamond::compile
#
# Class to build Diamond package.
#
class diamond::compile {

  exec {'fix_version.sh':
    command => "sed -i 's/LOCAL_REV=\"-github_archive\"/LOCAL_REV=\"\"/' /tmp/Diamond-${diamond::version}/version.sh",
    unless  => "grep -ri '    LOCAL_REV=\"\"' /tmp/Diamond-${diamond::version}/version.sh",
    path    => '/bin',
  }->

  case $::osfamily {
    'redhat': {
      exec { 'diamond_build_rpm':
        command => 'make rpm',
        creates => "/tmp/Diamond-${diamond::version}/build/diamond_${diamond::version}.0-0.noarch.rpm",
        cwd     => "/tmp/Diamond-${diamond::version}",
        path    => $::path,
        user    => 'root',
        group   => 'root',
      }
    }
    'debian': {
      exec { 'diamond_build_deb':
        command => 'make deb',
        creates => "/tmp/Diamond-${diamond::version}/build/diamond_${diamond::version}.0_all.deb",
        cwd     => "/tmp/Diamond-${diamond::version}",
        path    => $::path,
        user    => 'root',
        group   => 'root',
      }
    }
    default: { fail('Unrecognized operating system') }
}


}
