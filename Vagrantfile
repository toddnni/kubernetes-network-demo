# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'ipaddr'
require 'yaml'

x = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yaml'))
puts "Config: #{x.inspect}\n\n"

$prepare = <<SCRIPT
set -e
set -u
set -x
apt-get update
apt-get install -y docker.io
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.define "server-01" do |server|
    c = x.fetch('server')
    server.vm.box= "debian/buster64"
    server.vm.provider :libvirt do |domain|
      domain.memory = c.fetch('memory')
      domain.cpus = c.fetch('cpus')
    end
    server.vm.synced_folder ".", "/vagrant", type: "rsync"
    server.vm.network :private_network,
      :type => x.fetch('net').fetch('private_net_type'),
      :network_name => x.fetch('net').fetch('private_net_name'),
      :ip => x.fetch('ip').fetch('server')

    server.vm.hostname = "server-01"
    server.vm.provision "shell", inline: $prepare
    server.vm.provision "shell", path: "scripts/configure_rancher_server.sh", args: [
      x.fetch('ip').fetch('server'),
      x.fetch('admin_password'),
      x.fetch('rancher_version'),
      x.fetch('k8s_version'),
      x.fetch('net_iface')
    ]
  end

  node_ip = IPAddr.new(x.fetch('ip').fetch('node_start'))
  (1..x.fetch('node').fetch('count')).each do |i|
    c = x.fetch('node')
    hostname = "node-%02d" % i
    config.vm.define hostname do |node|
      node.vm.box   = "debian/buster64"
      node.vm.provider :libvirt do |domain|
        domain.memory = c.fetch('memory')
        domain.cpus = c.fetch('cpus')
      end
      node.vm.synced_folder ".", "/vagrant", type: "rsync"
      node.vm.network :private_network,
        :type => x.fetch('net').fetch('private_net_type'),
        :network_name => x.fetch('net').fetch('private_net_name'),
        :ip => IPAddr.new(node_ip.to_i + i - 1, Socket::AF_INET).to_s

      node.vm.hostname = hostname
      node.vm.provision "shell", inline: $prepare
      node.vm.provision "shell", path: "scripts/configure_rancher_node.sh", args: [
        x.fetch('ip').fetch('server'),
        x.fetch('admin_password'),
        x.fetch('net_iface')
      ]
    end
  end

end
