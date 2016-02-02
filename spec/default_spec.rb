describe 'jetty::default' do
  before do
    stub_command('test -d /usr/local/src/jetty-distribution-8.1.5.v20120716').and_return(true)
    stub_command('test -d /usr/share/jetty/lib').and_return(true)
    stub_command('test -f /usr/share/jetty/start.jar').and_return(true)
    stub_command('ps ax | grep jetty | grep -v grep').and_return(false)
  end

  context 'default' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'should not use daemon to start jetty' do
      expect(chef_run).to_not render_file('/etc/init.d/jetty').with_content('. /etc/rc.d/init.d/functions')
      expect(chef_run).to_not render_file('/etc/init.d/jetty').with_content('daemon --user')
    end
  end

  context 'centos' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5').converge(described_recipe)
    end

    it 'should use daemon to start jetty' do
      expect(chef_run).to render_file('/etc/init.d/jetty').with_content('. /etc/rc.d/init.d/functions')
      expect(chef_run).to render_file('/etc/init.d/jetty').with_content('daemon --user')
    end
  end
end
