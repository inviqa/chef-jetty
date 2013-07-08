if Chef::Config[:solo]
    node.expand!('disk')
else
    node.expand!('server')
end

default["jetty"]["version"]   = "8.1.5.v20120716"
default["jetty"]["link"]      = "http://archive.eclipse.org/jetty/#{node['jetty']['version']}/dist/jetty-distribution-#{node['jetty']['version']}.tar.gz"
default["jetty"]["checksum"]  = "95d14a2937092f0e2ae5ac87ad5c306662fa2ce965f9b950dd0dc38730e32b4d" # SHA256
default["jetty"]["directory"] = "/usr/local/src"
default["jetty"]["download"]  = "#{node['jetty']['directory']}/jetty-distribution-#{node['jetty']['version']}.tar.gz"
default["jetty"]["extracted"] = "#{node['jetty']['directory']}/jetty-distribution-#{node['jetty']['version']}"

default["jetty"]["user"]      = "jetty"
default["jetty"]["group"]     = "adm"
default["jetty"]["home"]      = "/usr/share/jetty"
default["jetty"]["port"]      = 8983
default["jetty"]["hidden_port"] = 8983 if node['jetty']['port'].to_i < 1024

default["jetty"]["log_dir"]   = "/var/log/jetty"
default["jetty"]["cache"]     = "/var/cache/jetty"
