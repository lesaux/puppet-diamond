require 'spec_helper'

describe 'diamond', :type => :class do

  context 'Redhat no parameters' do
    let (:facts) { {:osfamily => 'Redhat'} }

    it { should contain_package('diamond').with_ensure('present')}
    it { should create_class('diamond::config')}
    it { should create_class('diamond::install')}
    it { should create_class('diamond::service')}

    it { should contain_file('/etc/diamond/diamond.conf').with_content(/interval = 30/)}

    it { should contain_file('/etc/diamond/collectors').with('purge' => 'false')}

    it { should_not contain_package('python-pip')}
    it { should_not contain_package('librato-metrics')}

    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.libratohandler.LibratoHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.riemann.RiemannHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/^\s*path_prefix =/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/^\s*path_suffix =/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/^handlers_path =/)}

    it { should contain_service('diamond').with_ensure('running').with_enable('true') }
  end

  context 'Redhat with a custom graphite host' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'graphite_host' => 'graphite.example.com'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = graphite.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.libratohandler.LibratoHandler/)}
  end

  context 'Redhat with a custom graphite host and handler' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'graphite_host' => 'graphite.example.com', 'graphite_handler' => 'graphitepickle.GraphitePickleHandler'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = graphite.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphitepickle.GraphitePickleHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.libratohandler.LibratoHandler/)}
  end

  context 'Redhat with a custom graphite port and graphite pickle port' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'graphite_port' => '2013', 'pickle_port' => '2014'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/port = 2013/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/port = 2014/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/port = 2003/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/port = 2004/)}
  end

  context 'Redhat with a custom logger_level and rotate_level of logging' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'logger_level' => 'DEBUG', 'rotate_level' => 'INFO'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/level = DEBUG/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/level = INFO/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/level = WARNING/)}
  end

  context 'Redhat when specifing the number days to keep logs' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) {{ 'rotate_days' => '42' }}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/days = 42/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/args = \('\/var\/log\/diamond\/diamond.log', 'midnight', 1, 42\)/)}
  end

  context 'Redhat with a riemann host' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'riemann_host' => 'riemann.example.com'} }
    it { should contain_package('python-pip')}
    it { should contain_package('bernhard').that_comes_before('Package[python-pip]')}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = riemann.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.riemann.RiemannHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.libratohandler.LibratoHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
  end

  context 'Redhat with librato settings' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'librato_user' => 'bob', 'librato_apikey' => 'jim'} }
    it { should contain_package('python-pip')}
    it { should contain_package('librato-metrics').that_comes_before('Package[python-pip]')}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.libratohandler.LibratoHandler/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/user = bob/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/apikey = jim/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
  end

  context 'Redhat with librato and graphite settings' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'graphite_host' => 'graphite.example.com', 'librato_user' => 'bob', 'librato_apikey' => 'jim'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.libratohandler.LibratoHandler/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/user = bob/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/apikey = jim/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = graphite.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
  end

  context 'Redhat with a version' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'version' => '4.0'} }
    it { should contain_package('diamond').with_ensure('present')}
  end

  context 'Redhat with a custom polling interval' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'interval' => 10} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/interval = 10/)}
  end

  context 'Redhat with a extra handlers' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'extra_handlers' => ['diamond.handler.stats_d.StatsdHandler',]} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.stats_d.StatsdHandler/)}
  end

  context 'Redhat with service instructions' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'start' => false, 'enable' => false} }
    it { should contain_service('diamond').with_ensure('stopped').with_enable('false') }
  end

  context 'Redhat with a path_prefix' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'path_prefix' => 'undefined'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/^\s*path_prefix = undefined$/)}
  end

  context 'Redhat with a path_suffix' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'path_suffix' => 'undefined'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/^\s*path_suffix = undefined$/)}
  end

  context 'Redhat with a handlers_path' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let(:params) { {'handlers_path' => '/opt/diamond/handlers'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/handlers_path = \/opt\/diamond\/handlers/)}
  end

  context 'Redhat with purging collectors' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let (:params) { {'purge_collectors' => true} }
    it { should contain_file('/etc/diamond/collectors').with('purge' => 'true')}
  end

  context 'Redhat with not purging collectors' do
    let (:facts) { {:osfamily => 'Redhat'} }
    let (:params) { {'purge_collectors' => false} }
    it { should contain_file('/etc/diamond/collectors').with('purge' => 'false')}
  end

end
