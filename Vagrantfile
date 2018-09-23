Vagrant.configure(2) do |config|

  aws_cfg = JSON.parse(File.read("aws.json"))

  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  # forward ports from host to virtualbox vm
  config.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "udp"
  config.vm.network "forwarded_port", guest: 8081, host: 8081, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 8081, host: 8081, protocol: "udp"

  # loop through each node of JSON
  aws_cfg['ec2s'].each do |node|
    node_name = node[0]
    node_value = node[1]

    # configure this node
    config.vm.define node_name do |config2|
      # node tags
      ec2_tags = node_value['tags']

      config2.vm.provider :aws do |ec2, override|
        ec2.keypair_name = ENV['VAGRANT_AWS_KEYPAIR_NAME']
        ec2.access_key_id = ENV['VAGRANT_AWS_ACCESS_KEY']
        ec2.secret_access_key = ENV['VAGRANT_AWS_SECRET_KEY']
        override.ssh.private_key_path = ENV['VAGRANT_AWS_KEYPATH']
        ec2.security_groups = "vish_devops_experiments"

        # read region, ami etc from json.
        ec2.region = aws_cfg['region']
        ec2.availability_zone = aws_cfg['region']+aws_cfg['availability_zone']
        ec2.ami = node_value['ami']
        ec2.instance_type = node_value['instance_type']
        override.ssh.username = aws_cfg['ssh_username']

        ec2.tags = {
          'Name'         => node_name,
          'Role'         => node_name,
        }

      end
    end
  end

  # python required for ansible
  config.vm.provision :shell, inline: "sudo apt-get update -qqy && sudo apt-get install -qqy python"

  # use ansible to run a playbook.
  # if we want to switch to say, chef or puppet we should be able
  # to do that here.
  # the playbook will in turn, setup a docker environment.

  config.vm.provision "ansible" do |ansible|
    ansible.groups = {
      "docker" => ["1_app_server","2_mon_ci","3_docker"],
      "monitors" => ["2_mon_ci"],
      "registry" => ["3_docker"],
      "ci" => ["2_mon_ci"]
    }

    ansible.playbook = "provisioning/playbook.yml"
    ansible.verbose = "vv"
    ansible.galaxy_role_file = "provisioning/requirements.yml"
    ansible.galaxy_roles_path = "provisioning/"

  end

end
