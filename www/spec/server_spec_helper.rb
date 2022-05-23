=begin

require 'serverspec'
set :backend, :exec # :ssh


set :ssh_options, :user => 'vagrant', :password => 'vagrant', :host_name => 'www.localhost'
host = "gitlab.local"
options = Net::SSH::Config.for(host)
user = options[:user] = 'vagrant'
options[:password] = 'vagrant'
ENV['SUDO_PASSWORD'] =  options[:password]
set :host, options[:host_name] || host
set :ssh_options, options
set :disable_sudo, true
set :path, '/sbin:/usr/local/sbin:$PATH'

RSpec.configure do |c|
  c.host  = host
  c.request_pty = true
  c.ssh = Net::SSH.start(c.host, user)
end

=end
