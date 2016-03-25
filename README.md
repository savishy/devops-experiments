# devops-experiments

**Task Summary**

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

6. Recommeneded tool for AWS : Vagrant

## Task Notes ##




