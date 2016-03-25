# devops-experiments

##### Table of Contents  

1. [Summary of Task](#summary)
2. [My Notes](#mynotes)
  1. [Steps Followed](#stepsfollowed)
  2. [Troubleshooting](#troubleshooting)

<a name="summary"/>
## Summary of Task ##

Set up one click deploy and provisioning of an environment with all neccessary elements of a DevOps Toolchain.

**Description**

Use Puppet / Chef / Ansible for the following setup

1. Apache tomcat server
2. Mysql Database, with configuration controlled through the tool
3. Apache Http Webserver
4. Web loadbalancer on Apache Server for Tomcat.
5. Jenkins for CI
 
With the setup in place:

1. Make a continuous delivery (CD) pipeline using Jenkins, it should include CI Builds and other jobs neccessary for the software delivery lifecycle

2. Create a DevOps Toolchain to completely automate the pipeline
 
3. Push a built WAR using Jenkins build pipeline into the VM
 
4. Also make sure that the location of tomcat and apache HTTPD should be flexible and controlled by Puppet/Chef/Ansible, in case no specific value is provided it should fall back to defaults
 
**NOTES:**
 
1. You can make any assumptions and be as innovative and creative as possible in your usage of tools for DevOps tool-chain
 
2. You are expected to implement a CD pipeline with no use of shell scripts
 
3. Check-in the complete project (cookbooks, manifests, Jenkins build definitions etc.) into a GitHub account and send us the repository location
 
4. Use the spring application https://github.com/spring-projects/spring-petclinic/ as source for the CI And CD implementations.

5. Feel free to use AWS and share the working installation URL also.

6. Recommended tool for AWS : Vagrant

<a name="mynotes"/>
## My Notes ##

#### Introduction

1. It was my first exposure to nearly all the tools required in the assignment, so this was a great learning experience. 


#### Time Tracking

1. Reading: 1h
2. Downloads and Installs: 1h
3. 


#### References

Deploying on EC2 with Vagrant
http://www.iheavy.com/2014/01/16/how-to-deploy-on-amazon-ec2-with-vagrant/

Configuring Ansible Tower with Vagrant
https://www.ansible.com/tower-trial

Search for Vagrant Boxes
https://atlas.hashicorp.com/boxes/search

Puppet Pre-install
https://docs.puppetlabs.com/puppet/3.8/reference/pre_install.html#standalone-puppet

#### Choices made 

1. Of Puppet, Chef and Ansible, I chose Ansible. 
2. Ideally I would have tried out all 3 tools and made an educated choice. 
3. But in the given time for the assignment, the few reviews I read seemed to indicate similar attributes for all 3 tools. Thus my choice.
4. An additional weighting factor in favor of Ansible was that it seems easy to configure vagrant with an Ansible tower. 
5. [I read that](https://docs.puppetlabs.com/puppet/3.8/reference/pre_install.html#standalone-puppet) Puppet Master does not work on Windows. Given that my primary machine at home is Windows I discarded Puppet. 



#### Steps Followed

1. Learned the basics of Vagrant, Ansible 
2. Downloaded and installed Vagrant. 
2. Created an Ansible Tower VM (on localhost) 


<a name="troubleshooting"/>
## Troubleshooting

### Vagrant + Ansible Setup: Error when booting VirtualBox Image ###
While starting up an Ansible Tower VM with Vagrant `vagrant up`, I received this error:

![vagrant console error](https://cloud.githubusercontent.com/assets/13379978/14041575/3da148d4-f298-11e5-8bbb-75a9c7e0ffd0.PNG)

The installation process had installed VirtualBox on my machine automatically, and created a VM. So I opened VirtualBox and tried to start the just-created VM. 
This showed me a more helpful error:

![VirtualBox Error](https://cloud.githubusercontent.com/assets/13379978/14041574/3d9f228e-f298-11e5-9c2b-ace976d11413.PNG)

**Solution**

1. Went to BIOS and enabled VT-x. (Lenovo-specific option: Configuration > Virtualization > Enabled). 
2. Restarted Machine and VM. 
3. This time the Ansible Tower VM came up properly. :+1:

