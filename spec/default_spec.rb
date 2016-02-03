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

    it 'should set the jetty download location to be in chef cache' do
      expect(chef_run.node['jetty']['download']).to start_with(Chef::Config[:file_cache_path])
    end
  end
end
