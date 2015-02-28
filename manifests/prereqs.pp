# == Class: diamond::prereqs
#
# Class to install Diamond compilation pre-requirements.
#
class diamond::prereqs {

case $::osfamily {
  'redhat': {
    ensure_packages( ['make','rpm-build','python-configobj'] )
  }
  'debian': {
    ensure_packages( ['make','pbuilder','python-mock','python-configobj','python-support','cdbs'] )
  }
  default: { fail('Unrecognized operating system') }
}


}
