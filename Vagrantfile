# -*- mode: ruby -*-
# vi: set ft=ruby :


# https://github.com/hashicorp/vagrant/issues/1874#issuecomment-165904024
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |p|
    pm = Vagrant::Plugin::Manager.new(
      Vagrant::Plugin::Manager.user_plugins_file
    )
    plugin_hash = pm.installed_plugins
    next if plugin_hash.has_key?(p)
    result = true
    logger.warn("Installing plugin #{p}")
    pm.install_plugin(p)
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

required_plugins = ['vagrant-hosts', 'vagrant-share', 'vagrant-vbox-snapshot', 'vagrant-host-shell', 'vagrant-reload']
ensure_plugins required_plugins



Vagrant.configure(2) do |config|
  config.vm.define "kerberos_server" do |kerberos_server_config|
    kerberos_server_config.vm.box = "bento/centos-7.4"
    kerberos_server_config.vm.hostname = "kdc.codingbee.net"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    kerberos_server_config.vm.network "private_network", ip: "192.168.10.100", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    kerberos_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_kerberos_server"
    end

    kerberos_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    kerberos_server_config.vm.provision "shell", path: "scripts/setup-kdc-authentication-system.sh", privileged: true
  end



  config.vm.define "kerberos_client1" do |kerberos_client1_config|
    kerberos_client1_config.vm.box = "bento/centos-7.4"
    kerberos_client1_config.vm.hostname = "krb-client1.codingbee.net"
    kerberos_client1_config.vm.network "private_network", ip: "192.168.10.101", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    kerberos_client1_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_kerberos_client1"
    end

    kerberos_client1_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    kerberos_client1_config.vm.provision "shell", path: "scripts/setup-kerberos-client.sh", privileged: true
  end

  config.vm.define "kerberos_client2" do |kerberos_client2_config|
    kerberos_client2_config.vm.box = "bento/centos-7.4"
    kerberos_client2_config.vm.hostname = "krb-client2.codingbee.net"
    kerberos_client2_config.vm.network "private_network", ip: "192.168.10.102", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    kerberos_client2_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_kerberos_client2"
    end

    kerberos_client2_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    kerberos_client2_config.vm.provision "shell", path: "scripts/setup-kerberos-client.sh", privileged: true
  end


  # this line relates to the vagrant-hosts plugin, https://github.com/oscar-stack/vagrant-hosts
  # it adds entry to the /etc/hosts file. 
  # this block is placed outside the define blocks so that it gts applied to all VMs that are defined in this vagrantfile. 
  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '192.168.10.100', ['kdc.codingbee.net']  
    provisioner.add_host '192.168.10.101', ['krb-client1.codingbee.net']
    provisioner.add_host '192.168.10.102', ['krb-client2.codingbee.net']
  end


end
