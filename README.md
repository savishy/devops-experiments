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
2. The Ansible Playbook  **configures the environment on the host to be able
   to launch Docker containers.**
3. The Docker containers encapsulate building and running the application.

### Vagrant ###

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

Docker does the heavy lifting of building and running the application.

There are two Docker containers:

1. A Docker container running tomcat.
2. A Docker container running Jenkins.


**Docker Jenkins**:

1. The Jenkins container listens to commits to the
[Pet Clinic Github repository](http://github.com/spring-projects/spring-petclinic).
1. When commits are made to the repository, a WAR is automatically built and
tested.

If tests pass, a Docker image is built containing

* tomcat
* the application WAR
* appropriate configs for tomcat.


## Troubleshooting and Notes

1. **Tomcat Ports and EC2 Security Groups**

Apparently both ports 80 and 8080 have to be exposed in the EC2 Security
Group.

1. **Starting Docker Service in Ansible**

In Ansible Playbook, I had trouble restarting the docker service using handler (i.e
the guy that takes care of restarting the docker service).

Ultimately I just removed the `handler` approach completely and inlined the
step that restarts docker.

1. **Using Jenkins to build Docker Images**

*References*

The links below are good for some light reading.

1. http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
1. Unofficial Docker-in-Docker image https://github.com/jpetazzo/dind
1. Official Docker-in-Docker image https://hub.docker.com/_/docker/
1. https://forums.docker.com/t/using-docker-in-a-dockerized-jenkins-container/322/2
1. Configuring Docker Daemon on Ubuntu 15.04 http://nknu.net/how-to-configure-docker-on-ubuntu-15-04/

* The Jenkins Docker Container is supposed to create Docker images.
* This means it needs to have access to the Docker Daemon.
* The initial approach would be to install Docker *within this Docker
  Container.*
* But
  [research tells me](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)
  this is a bad thing in a lot of ways.

So, the recommended approach is for *Jenkins to be able to connect to Docker
daemon running on the host.*

1. First start Docker as a daemon using
   [this guide for Ubuntu 15 and above.](http://nknu.net/how-to-configure-docker-on-ubuntu-15-04/)

   Note: this will start Docker Daemon with options `-H tcp://0.0.0.0:2375 -H
   unix:///var/run/docker.sock`.
   
   Check `systemctl status docker`. The logs should show something like 
   ```
   level=info msg="API listen on [::]:2375"
   ```
   Which indicates that Docker Daemon is listening on port 2375.
   
   *Security Note: `0.0.0.0` [is insecure](http://stackoverflow.com/a/26029365/682912).*







