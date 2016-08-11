# Ansible managed: /home/vish/vishy/devops-agility-roots/devops-experiments/roles/docker_jenkins/templates/Dockerfile.jenkins modified on 2016-08-09 11:31:12 by vish on freeman
# This is just a proof of concept.
FROM ubuntu:16.04

# install common packages
RUN apt-get update -qqy
RUN apt-get install -y wget software-properties-common curl git openjdk-8-jdk-headless

# env vars
ENV JENKINS_HOME /var/lib/jenkins
ENV JAVA_OPTS "-Djava.awt.headless=true -Dhudson.diyChunking=false"
ENV JENKINS_OPTS "--httpPort=8081"
# install Jenkins
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update -qqy --allow-unauthenticated
RUN apt-get install -y jenkins

# create job config
RUN mkdir -p $JENKINS_HOME/ref $JENKINS_HOME/jobs/petclinic-build/ $JENKINS_HOME/jobs/petclinic-docker/
# copy job config as root (no other way)
COPY jobs/petclinic-build/config.xml $JENKINS_HOME/jobs/petclinic-build/config.xml
COPY jobs/petclinic-docker/config.xml $JENKINS_HOME/jobs/petclinic-docker/config.xml

# Copy credentials for docker hub (TODO issue #11)
COPY credentials.xml  $JENKINS_HOME

# Global config for docker build steps
COPY org.jenkinsci.plugins.dockerbuildstep.DockerBuilder.xml $JENKINS_HOME

# Add Jenkins Plugins list
COPY plugins.txt $JENKINS_HOME/plugins.txt
COPY plugin.sh $JENKINS_HOME/plugin.sh

# Download Plugin HPIs to plugins folder
WORKDIR $JENKINS_HOME
RUN sh -c "$JENKINS_HOME/plugin.sh $JENKINS_HOME/plugins.txt"

# prevent jenkins from showing "unlock jenkins" dialog.
RUN echo 2.7.1 > $JENKINS_HOME/ref/jenkins.install.InstallUtil.lastExecVersion

# Start Jenkins!
CMD exec java $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS
