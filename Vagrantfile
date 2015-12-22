Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.enable :yum
    config.cache.enable :apt
  end
  
  config.vm.define "centos7pe" do |centos7pe|
    centos7pe.vm.box = "puppetlabs/centos-7.0-64-nocm"
    centos7pe.vm.hostname = "centos7pe.box"
    centos7pe.vm.network :private_network, ip: "172.16.16.21"
    centos7pe.vm.provision :shell, path: "scripts/centos7pe.sh"
  end 

end
