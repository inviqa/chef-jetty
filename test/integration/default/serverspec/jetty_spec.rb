require 'serverspec'
set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe 'Jetty' do
  describe user('jetty') do
    it { should exist }
    it { should belong_to_group 'adm' }
    it { should have_login_shell '/bin/false' }
    it { should have_home_directory '/usr/share/jetty' }
  end

  describe file('/etc/jetty') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  %w(/usr/share/jetty /usr/share/jetty/contexts
     /usr/share/jetty/webapps /var/cache/jetty).each do |dir|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by 'jetty' }
      it { should be_grouped_into 'adm' }
      it { should be_mode 755 }
    end
  end

  describe file('/usr/share/jetty/lib') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe file('/var/log/jetty') do
    it { should be_directory }
    it { should be_owned_by 'jetty' }
    it { should be_grouped_into 'adm' }
    it { should be_mode 700 }
  end

  describe file('/usr/share/jetty/etc') do
    it { should be_symlink }
    it { should be_linked_to '/etc/jetty' }
  end

  %w(/etc/default/jetty /etc/jetty/jetty.xml /etc/jetty/webdefault.xml
     /etc/jetty/jetty-deploy.xml /etc/jetty/jetty-logging.xml).each do |file|
    describe file(file) do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
    end
  end

  describe service('jetty') do
    it { should be_enabled }
    it { should be_running }
  end

  describe process('java') do
    its(:user) { should eq 'jetty' }
  end
end
