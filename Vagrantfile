# read JSON file
aws_cfg = JSON.parse(File.read("aws.json"))

# read and store env vars
keypair_name = ENV['AWS_KEYPAIR_NAME']
access_key_id = ENV['AWS_ACCESS_KEY']
secret_access_key = ENV['AWS_SECRET_KEY']
security_groups = ENV['AWS_SECURITYGROUP']
private_key_path = ENV['AWS_KEYPATH']

Vagrant.configure(2) do |config|

  config.vm.box = "perconajayj/centos-x86_64"

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
        ec2.keypair_name = keypair_name
        ec2.access_key_id = access_key_id
        ec2.secret_access_key = secret_access_key
        ec2.security_groups = security_groups
        override.ssh.private_key_path = private_key_path

        # read region, ami etc from json.
        # default(Mumbai) region, Amazon Linux, T2 Micro
        # (this combination is known to work)
        ec2.region = aws_cfg['region']
        ec2.availability_zone = aws_cfg['region']+aws_cfg['availability_zone']
        ec2.ami = node_value['ami_id']
        ec2.instance_type = node_value['instance_type']
        override.ssh.username = aws_cfg['ssh_username']

        ec2.tags = {
          'Name'         => ec2_tags['Name'],
          'Role'         => ec2_tags['Role'],
        }

      end
    end
  end

  # use ansible to run a playbook.
  # if we want to switch to say, chef or puppet we should be able
  # to do that here.
  # the playbook will in turn, setup a docker environment.

  
  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "vvvv"
    ansible.playbook = "playbook.yml"
  end
  
end
