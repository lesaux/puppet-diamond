class diamond::git {

  if $diamond::install_method == 'git' {

    vcsrepo { "/tmp/Diamond-v${diamond::version}":
      ensure   => present,
      provider => git,
      source   => 'git://github.com/python-diamond/diamond.git',
      revision => "v${diamond::version}",
    }

  }

}
