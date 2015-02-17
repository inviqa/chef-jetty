describe 'chef-jetty::default' do
  before {
    stub_command("test -d /usr/local/src/jetty-distribution-8.1.5.v20120716").and_return(true)
    stub_command("test -d /usr/share/jetty/lib").and_return(true)
    stub_command("test -f /usr/share/jetty/start.jar").and_return(true)
    stub_command("ps ax | grep jetty | grep -v grep").and_return(false)
  }

  context 'centos' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5').converge 'jetty::default' }

    it 'should use daemon to start jetty' do
      expect(chef_run).to render_file('/etc/init.d/jetty').with_content('. /etc/rc.d/init.d/functions')
      expect(chef_run).to render_file('/etc/init.d/jetty').with_content('daemon --user')
    end
  end
end
