Vagrant.configure(2) do |config|
  config.vm.provider :aws do |aws, override|

    # is this needed?
    config.vm.box = "lattice/ubuntu-trusty-64"

    # read security data from local environment variables.
    
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.security_groups = ENV['AWS_SECURITYGROUP']
    override.ssh.private_key_path = ENV['AWS_KEYPATH']

    # Mumbai region, Amazon Linux, T2 Micro
    # (this combination is known to work)
    aws.ami = "ami-ffbdd790"
    aws.region = "ap-south-1"
    aws.instance_type = "t2.micro"
    override.ssh.username = "ec2-user"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = "v"
    ansible.playbook = "playbook.yml"
  end
  
end
