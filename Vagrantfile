# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true

  config.vm.box = 'ubuntu/xenial64'
  config.vm.box_version = '20161026.0.0'
  config.vm.box_check_update = false
  # node.js
  config.vm.network 'forwarded_port', guest: 8000, host: 8000
  # webpack dev server for css and js
  config.vm.network 'forwarded_port', guest: 3001, host: 3001

  # Not setting hostname for now since Vagrant will restart container interface
  # enabling DHCP again
  #
  config.vm.host_name = 'katuma'

  config.vm.provider :virtualbox do |vb|
    vb.memory = '2048'
  end

  config.vm.provision "shell", inline: "sudo apt-get install -qq python2.7"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "development.yml"
    ansible.verbose = "v"
    ansible.ask_sudo_pass = true
    ansible.ask_vault_pass = true

    ansible.groups = {
      "katuma-dev" => ["default"]
    }
  end

  config.vm.provision "file", source: "setup_repos.sh", destination: "~/setup_repos.sh"
end
