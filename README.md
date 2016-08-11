# DevOps Experiments (Attempt 2) #

This branch (`attempt-2`) deals with an alternate approach to creating a
one-click DevOps CI/CD Pipeline.

This branch utilizes:

- Vagrant
- Ansible
- Docker
- AWS

## How to Run ##

To run this on Virtualbox, type `vagrant up`.

To run this on AWS:

1. Type: `vagrant up --provider=aws`.
1. Then go to your AWS management console and wait for the instance to come
   up. Afterward, use the public DNS address of the instance with `:8080` to
   launch the web application.


This will do the following:

1. Bring up a box in AWS using Vagrant.
1. Install Docker in that box.
1. Run a Dockerfile to build a Jenkins image.
1. Run a Jenkins Docker container using that image.
1. In this Jenkins container, create jobs for:
   - building the sample petclinic-application into a WAR
   - deploying that WAR into a Dockerized tomcat application.
1. Run the jobs so that the petclinic Docker image is built successfully.

## Implementation Notes ##

### Vagrant ###

Details about Vagrantfile:

1. The `Vagrantfile` uses a Vagrant box that is available for both
   `virtualbox` and `aws` providers. This enables the flow of "develop
   locally, deploy to aws".

1. The `Vagrantfile` deals with provisioning of an EC2 instance *as well as
   running an Ansible playbook.* (Previously I was launching the Ansible
   playbook separately)

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

1. The only role of the `Vagrantfile` is to setup the virtualization
   environment.
   This makes it easy if we are swapping out AWS (for eg) with Virtualbox.

1. The AWS Instance is created with settings
    - aws.ami = "ami-ffbdd790"
    - aws.region = "ap-south-1" (i.e Mumbai)
    - aws.instance_type = "t2.micro"

1. I am using a Vagrant box that's supported for both `aws` and `virtualbox`
   providers. The idea is that I develop the scripts using `vagrant up`, then
   deploy them using `vagrant up --provider=aws`.

### Ansible ###

The Ansible Playbook's job is to run a playbook which:

1. configures the environment on the host for Docker
1. creates a Jenkins Docker container from Dockerfile, which also contains Jenkins
   job configurations for building `petclinic`
1. builds and runs Jenkins jobs

This makes it easy for us if we want to replace Ansible with say, Chef or
Puppet. (in such a case, the only thing we would need to do is to write
appropriate recipes to setup Docker).

### Docker ###

Docker contains all the configuration required for building and running the application.

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

1. The next issue is how to access the daemon inside a container. 
   The container should be started by bind-mounting the Docker socket as
   `docker run -v /var/run/docker.sock:/var/run/docker.sock ...`
   
   Now, locate the ip address of the host from within the container. 
   [Use this reference](http://stackoverflow.com/a/31328031/682912).
   
   Now verify that you can access the host from within the container using
   `curl http://172.17.0.1/info` (this is equivalent to running `docker info`
   on the host).
   
   Configure Jenkins Global Configuration ([hit apply!](http://stackoverflow.com/a/38541578/682912))





