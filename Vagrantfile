Vagrant::Config.run do |config|
  config.vm.box = "ruby_back_nine_base"
  config.vm.box_url = "https://s3.amazonaws.com/vagrant.cloudspace.com/cloudspace_ubuntu_12.04.box"

  config.vm.share_folder "ruby_back_nine", "/srv/ruby_back_nine", "./", :nfs => true
  config.vm.customize ["modifyvm", :id, "--memory", "1536", "--name", "rubygolf-dev","--cpus", "2"]
  # config.vm.boot_mode = :gui
  config.vm.network :hostonly, '33.33.33.77'
  config.ssh.private_key_path = File.join(ENV['HOME'], '.ssh', 'cs_vagrant.pem')

  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = 'https://api.opscode.com/organizations/cloudspace'
    chef.validation_key_path = File.join(ENV['HOME'], '.ssh', 'cloudspace-validator.pem')
    chef.validation_client_name = 'cloudspace-validator'

    case ENV['USER']
    when 'nthomson'
        chef.node_name = "rubygolf_vagrant_nick"
    else
        chef.node_name = "rubygolf_vagrant_#{ENV['USER']}"
    end

    chef.add_recipe "ubuntu"
    chef.add_recipe "mysql::client"
    chef.add_recipe "mysql::server"
    chef.add_recipe "apache2"

    chef.json = {
      :mysql => {
         :server_root_password => '8DF892JAjdfj2903ijV3lsdf2'
      }
    }
   end
end
