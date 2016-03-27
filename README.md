# devops-experiments

##### Table of Contents  

1. [Summary of Task](#summary)
2. [My Notes](#mynotes)
  1. [Steps Followed](#stepsfollowed)
    1. [Ansible Tower](#ansibletower)
    2. [EC2 with Vagrant](#ec2vagrant)
  2. [Troubleshooting](#troubleshooting)
  3. [References](#references)

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
4. Use the spring application https://github.com/spring-projects/spring-petclinic/ as source for the CI And CD implementations
5. Feel free to use AWS and share the working installation URL also.
6. Recommended tool for AWS : Vagrant

<a name="mynotes"/>
## My Notes ##

#### Introduction

1. It was my first exposure to nearly all the tools required in the assignment, so this was a great learning experience. 
2. A lesson I'd learned previously, which has now been reinforced: Windows can interfere with the development process. Always have a Linux box ready!

#### Time Tracking

*Day 1: Creating a local Ansible Tower VM with Vagrant: 4h*

1. Reading: 1h
2. Downloads and Installs: 3h

*Day 1: Creating and Configuring Amazon EC2 Image with Vagrant: 4h*

1. Reading: 30m
2. Configuration: 30m
3. Troubleshooting: 3h

*Day 1/2: Creating a Dev Environment with Ansible: 12h*

1. Reading: 3h
2. Configuration: 4h
3. Troubleshooting: 5h

*Day 3:*

1.
2.
3.

#### Choices made 

1. Of Puppet, Chef and Ansible, I chose Ansible. 
  1. Ideally I would have tried out all 3 tools and made an educated choice. 
  3. But in the given time for the assignment, the few reviews I read seemed to indicate similar attributes for all 3 tools. Thus my choice.
  4. An additional weighting factor in favor of Ansible was that it seems easy to configure vagrant with an Ansible tower. 
  5. [I read that](https://docs.puppetlabs.com/puppet/3.8/reference/pre_install.html#standalone-puppet) Puppet Master does not work on Windows. Given that my primary machine at home is Windows I discarded Puppet. 
2. I chose [geerlingguy/jenkins](https://github.com/geerlingguy/ansible-role-jenkins) for the relative ease of configuring Jenkins as an Ansible role. 
3. I set up Jenkins on the same machine as the web server.

<a name="stepsfollowed"/>
#### Steps Followed

<a name="ansibletower"/>
##### Ansible Tower Installation

Within the repo, run the following (assuming Vagrant installed):

```
cd ansible-tower
vagrant up
vagrant ssh
```

1. This gives you credentials to Ansible Tower GUI as well as SSHing into the Tower Instance.
![image of successful ssh.](https://cloud.githubusercontent.com/assets/13379978/14041895/1f19ad90-f29b-11e5-9c70-c4429e773de7.png)
* I did not have to use the GUI at all beyond initial exploration. 
1. My experiments were conducted with *Ansible Basic Tower*. The Enterprise tower license required a delay of 1 business day.
3. I have used Vagrant to bring up Ansible Tower as per the Ansible docs.
4. The first `vagrant up` caused some issues that I solved (see [troubleshooting](#troubleshooting)).
4. [See image of Ansible Dashboard.](https://cloud.githubusercontent.com/assets/13379978/14042281/8134348e-f29e-11e5-9796-a826143f2d9d.png)

<a name="ec2vagrant"/>
##### Deploying Amazon EC2 with Vagrant

Details:

* m3.medium
* Region: Singapore
* AMI: ami-e90dc68a
* Vagrant Box Used: [lattice/ubuntu-trusty-x64](https://atlas.hashicorp.com/lattice/boxes/ubuntu-trusty-64)

[See image of successful launch.](https://cloud.githubusercontent.com/assets/13379978/14044040/84e61332-f2b1-11e5-9415-3be0d2e535ed.png)

Details on Connecting to Instance:

1. Make sure `vagrant-aws` plugin is installed.
2. Place the `devops.pem` at the top of the repository. 
2. `cd ec2-i-f9eaa477`
3. `vagrant up --provider=aws`
4. (Alternatively you can also SSH in)
5. During my attempt, I encountered and solved several issues. (See [troubleshooting](#troubleshooting)).


<a name="references"/>
#### References

* [Deploying on EC2 with Vagrant](http://www.iheavy.com/2014/01/16/how-to-deploy-on-amazon-ec2-with-vagrant/)
* [Configuring Ansible Tower with Vagrant](https://www.ansible.com/tower-trial)
* [Search for Vagrant Boxes](https://atlas.hashicorp.com/boxes/search)
* [Puppet Pre-install](https://docs.puppetlabs.com/puppet/3.8/reference/pre_install.html#standalone-puppet)
* [Ansible AWS Guide](http://docs.ansible.com/ansible/guide_aws.html)
* [Configuring vagrant-aws](https://github.com/mitchellh/vagrant-aws)
* [Connecting to AWS Instances from Windows](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html)
* [Maven Wrapper](https://github.com/takari/maven-wrapper)
* [Ansible and Jenkins](http://codeheaven.io/an-introduction-to-ansible/)
* [geerlingguy/jenkins](https://github.com/geerlingguy/ansible-role-jenkins)
* other: 
[1](http://stackoverflow.com/questions/5109112/how-to-deploy-a-war-file-in-tomcat-7), [2](https://github.com/ansible/ansible-examples), 
[3](http://docs.ansible.com/ansible/playbooks_roles.html#role-default-variables),
[4](http://docs.ansible.com/ansible/file_module.html),
[5](http://docs.ansible.com/ansible/intro_configuration.html#getting-the-latest-configuration),
[6](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)


<a name="troubleshooting"/>
## Troubleshooting

##### Vagrant + Ansible Setup: Error when booting VirtualBox Image
While starting up an Ansible Tower VM with Vagrant `vagrant up`, I received this error:

[vagrant console error](https://cloud.githubusercontent.com/assets/13379978/14041575/3da148d4-f298-11e5-8bbb-75a9c7e0ffd0.PNG)

The installation process had installed VirtualBox on my machine automatically, and created a VM. So I opened VirtualBox and tried to start the just-created VM. 
This showed me a more helpful error:

[VirtualBox Error](https://cloud.githubusercontent.com/assets/13379978/14041574/3d9f228e-f298-11e5-9c2b-ace976d11413.PNG)

**Solution**

1. Went to BIOS and enabled VT-x. (Lenovo-specific option: Configuration > Virtualization > Enabled). 
2. Restarted Machine and VM. 
3. This time the Ansible Tower VM came up properly. :+1:

##### SSH to EC2 instance: PEM file permissions cannot be changed by cygwin

Before Connecting to the EC2 instance using the downloaded PEM File, I would need to change the file's permissions to `0400`. 

However, on my Windows + Cygwin laptop, changing the permissions did not appear to work at all.

After tearing my hair out some, I figured out how to successfully change the permissions and connect to the machine. :+1:
See the problem screenshots and solution [in this comment.](https://github.com/savishy/devops-experiments/issues/1#issuecomment-201237692) 

##### Errors while deploying and connecting to Vagrant Box with EC2

I encountered multiple issues while exploring deployment of a Vagrant box to the EC2 Image. 
See problems and solutions [here](https://github.com/savishy/devops-experiments/issues/1#issuecomment-201246495) and [here](https://github.com/savishy/devops-experiments/issues/1#issuecomment-201709309).
