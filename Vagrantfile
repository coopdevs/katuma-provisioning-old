# -*- mode: ruby -*-
# vi: set ft=ruby :

BACKEND_PROJECT_NAME = 'katuma'
FRONT_END_PROJECT_NAME = 'katuma-web'
VAGRANTFILE_API_VERSION = '2'

def fail_with_message(msg)
  fail Vagrant::Errors::VagrantError.new, msg
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true

  config.vm.box = 'ubuntu/xenial64'
  config.vm.box_version = '20161026.0.0'
  config.vm.box_check_update = false

  config.vm.network "private_network", type: "dhcp"
  # node.js
  config.vm.network 'forwarded_port', guest: 8000, host: 8000
  # webpack dev server for css and js
  config.vm.network 'forwarded_port', guest: 3001, host: 3001

  # Not setting hostname for now since Vagrant will restart container interface
  # enabling DHCP again
  #
  config.vm.host_name = 'katuma'

  # Link to your host machine
  if !Vagrant.has_plugin? 'vagrant-bindfs'
    fail_with_message "vagrant-bindfs missing, please install the plugin with this command:\nvagrant plugin install vagrant-bindfs"
  else
    [BACKEND_PROJECT_NAME, FRONT_END_PROJECT_NAME].each do |project_name|
      config.vm.synced_folder local_path(project_name), nfs_path(project_name), type: 'nfs'
      config.bindfs.bind_folder nfs_path(project_name), remote_path(project_name), u: 'ubuntu', g: 'ubuntu', o: 'nonempty'
    end
  end

  # Sync when a file change. This is needed because frontend
  # has hot module reload with Webpack and when a file change code must be reloaded
  #
  # Another way without Rsync
  # There is another way of make HOT RELOADING work. you can add:
  # watchOptions: { poll: true } on webpack-dev-middleware. poll can also be milliseconds
  #
  # Conclusions:
  # I've trying to make HOT RELOADING work with shared folders.
  # Both ways `rsync` and `webpack --watch` work. But neither of both have an acceptable
  # performance or respond time.
  config.vm.synced_folder local_path(FRONT_END_PROJECT_NAME),
                          remote_path(FRONT_END_PROJECT_NAME),
                          type: "rsync",
                          rsync__exclude: ".git/",
                          rsync__args: ["--verbose", "--rsync-path='sudo rsync'", "--archive", "--delete", "-z"]

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
end

def remote_path(project_name)
  "/home/ubuntu/#{project_name}"
end

def local_path(project_name)
  "../#{project_name}"
end

def nfs_path(project_name)
  "/vagrant-nfs-#{project_name}"
end
