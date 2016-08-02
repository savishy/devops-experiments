# DevOps Experiments (Attempt 2) #

This branch (`attempt-2`) deals with a second attempt at solving the DevOps
assignment.

1. To run this type: `vagrant up --provider=aws`.
1. Then go to your AWS management console and wait for the instance to come
   up. Afterward, use the public DNS address of the instance with `:8080` to
   launch the web application.

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

1. The only role of the Vagrantfile is to setup the virtualization
   environment.
   This makes it easy if we are swapping out AWS (for eg) with Virtualbox.

1. The AWS Instance is created with settings
    - aws.ami = "ami-ffbdd790"
    - aws.region = "ap-south-1" (i.e Mumbai)
    - aws.instance_type = "t2.micro"


### Ansible ###

The only role of Ansible is to run a playbook that installs and sets up Docker
on the instance.

(**compared to the previous attempt, where Ansible Playbook took charge of
installing and configuring the application and starting it)

This makes it easy for us if we want to replace Ansible with say, Chef or
Puppet. (in such a case, the only thing we would need to do is to write
appropriate recipes to setup Docker).

### Docker ###

Docker does the heavy lifting of configuring the application environment.

Since the application (in this case, a tomcat server) is Dockerized, it brings
all the scalability advantages of Docker.


## Troubleshooting

1. **Tomcat Ports and EC2 Security Groups**

Apparently both ports 80 and 8080 have to be exposed in the EC2 Security
Group.

1. **`service docker start`**

In Ansible Playbook, I had trouble restarting the docker service using handler (i.e
the guy that takes care of restarting the docker service).

Ultimately I just removed the `handler` approach completely and inlined the
step that restarts docker.

