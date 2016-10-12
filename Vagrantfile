# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true

  config.vm.box = 'fgrehm/trusty64-lxc'

  # Not setting hostname for now since Vagrant will restart container interface
  # enabling DHCP again
  #
  config.vm.host_name = 'katuma'

  config.vm.provider :lxc do |lxc|
    lxc.container_name = 'katuma'
    # lxc.customize 'network.ipv4', '10.0.3.80/24'
    # lxc.customize 'network.ipv4.gateway', '10.0.3.1'
    # lxc.customize 'network.veth.pair', 'katuma'
    lxc.customize 'cgroup.memory.limit_in_bytes', '2048M'
  end

  # config.vm.provision :ansible do |ansible|
  #   ansible.playbook = 'site.yml'
  #   ansible.inventory_path = './hosts'
  #   ansible.limit = 'webservers'
  # end
end
