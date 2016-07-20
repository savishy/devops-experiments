# DevOps Experiments (Attempt 2) #

This branch (`attempt-2`) deals with a second attempt at solving the DevOps
assignment. 

## Summary ##

What's different from the `master` branch:

1. The `Vagrantfile` deals with provisioning of an EC2 instance *as well as
   running an Ansible playbook.* (Previously I was launching the Ansible
   playbook separately)

## Vagrant ##

Details about Vagrantfile

1. All sensitive data is retrieved from environment variables and stored *out
   of the Vagrantfile*. So to run `vagrant up --provider=aws` the following
   environment variables should be set:
   
   ```
   AWS_KEYPAIR_NAME: name of an AWS keypair
   AWS_ACCESS_KEY: your AWS Access Key
   AWS_SECRET_KEY: your AWS Secret Key
   AWS_SECURITYGROUP: A pre-created AWS security group that allows SSH from
   your IP Address. (see note below)
   AWS_KEYPATH: local location of the key PEM file.
   ```

1. The AWS Instance is created with settings
    - aws.ami = "ami-ffbdd790"
    - aws.region = "ap-south-1" (i.e Mumbai)
    - aws.instance_type = "t2.micro"
