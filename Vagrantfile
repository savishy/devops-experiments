Vagrant.configure(2) do |config|

  # We use Vagrant ONLY to setup the virtualized environment.
  # If we want to switch the environment to say VirtualBox
  # we can easily do that here.
  
  config.vm.provider :aws do |aws, override|

    # choosing a box that is supported for both
    # virtualbox and aws providers.
    # the idea is to "vagrant up" a local instance, run tests locally,
    # and deploy to "vagrant up --provider=aws" when it works properly.
    
    config.vm.box = "perconajayj/centos-x86_64"

    # forward ports from host to virtualbox vm
    config.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "tcp"
    config.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "udp"
    config.vm.network "forwarded_port", guest: 8081, host: 8081, protocol: "tcp"
    config.vm.network "forwarded_port", guest: 8081, host: 8081, protocol: "udp"
    
    # read security data from local environment variables.
    
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_KEY']
    aws.security_groups = ENV['AWS_SECURITYGROUP']
    override.ssh.private_key_path = ENV['AWS_KEYPATH']

    
    # default(Mumbai) region, Amazon Linux, T2 Micro
    # (this combination is known to work)
    aws.region = "ap-south-1"
    aws.ami = "ami-ffbdd790"
    aws.instance_type = "t2.micro"
    override.ssh.username = "ec2-user"
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
