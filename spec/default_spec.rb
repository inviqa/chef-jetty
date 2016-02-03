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

    it 'should create a jetty defaults file with the JETTY_HOME value set' do
      expect(chef_run).to render_file('/etc/default/jetty').with_content('JETTY_HOME=/usr/share/jetty')
    end

    it 'should create a jetty defaults file with the JETTY_USER value set' do
      expect(chef_run).to render_file('/etc/default/jetty').with_content('JETTY_USER=jetty')
    end

    it 'should create a jetty defaults file with the JAVA_OPTIONS not including solr' do
      expect(chef_run).to render_file('/etc/default/jetty')
        .with_content('JAVA_OPTIONS="-Djava.awt.headless=true"')
    end
  end

  context 'custom jetty home directory' do
    before do
      stub_command('test -d /var/lib/jetty/lib').and_return(true)
      stub_command('test -f /var/lib/jetty/start.jar').and_return(true)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['jetty']['home'] = '/var/lib/jetty'
      end.converge(described_recipe)
    end

    it 'should create a jetty defaults file with the JETTY_HOME value set' do
      expect(chef_run).to render_file('/etc/default/jetty').with_content('JETTY_HOME=/var/lib/jetty')
    end
  end

  context 'custom jetty user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['jetty']['user'] = 'a_user'
      end.converge(described_recipe)
    end

    it 'should create a jetty defaults file with the JETTY_USER value set' do
      expect(chef_run).to render_file('/etc/default/jetty').with_content('JETTY_USER=a_user')
    end
  end

  context 'with solr enabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['solr']['home'] = '/some/directory'
      end.converge(described_recipe)
    end

    it 'should create a jetty defaults file with the JAVA_OPTIONS not including solr' do
      expect(chef_run).to render_file('/etc/default/jetty')
        .with_content('JAVA_OPTIONS="-Djava.awt.headless=true -Dsolr.solr.home=/some/directory"')
    end
  end
end
