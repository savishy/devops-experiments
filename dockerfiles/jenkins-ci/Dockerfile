FROM jenkins:2.7.1

# install docker on Jenkins container
USER root
RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates lxc iptables
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list
RUN apt-get update
RUN apt-get install -y docker.io
RUN usermod -aG docker jenkins
USER jenkins

# Jenkins Port
# TODO jenkins security needs to be set with HTTPS, using JENKINS_OPTS
ENV JENKINS_OPTS --httpPort=8081

# fix for StreamCorruptedException when running Jenkins CLI
# https://issues.jenkins-ci.org/browse/JENKINS-35197
ENV JAVA_OPTS "-Djava.awt.headless=true -Dhudson.diyChunking=false"

ADD plugins.txt /usr/share/jenkins/ref/plugins.txt

# create job config
USER jenkins
RUN mkdir -p /var/jenkins_home/jobs/petclinic-build/
# copy job config as root (no other way)
COPY config.xml /var/jenkins_home/jobs/petclinic-build/config.xml
COPY credentials.xml  /var/jenkins_home/
COPY org.jenkinsci.plugins.dockerbuildstep.DockerBuilder.xml /var/jenkins_home/

# TODO cannot figure out how to copy and change permissions.
# Open issues on Docker indicate this is a bug.

# RUN chown -R jenkins:jenkins /var/jenkins_home/jobs/
# RUN chmod -R 755 /var/jenkins_home/jobs/petclinic-build/

# commands below are run as user jenkins
USER jenkins

# prevent jenkins from showing "unlock jenkins" dialog.
RUN echo 2.7.1 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

# install needed plugins 
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# unless these HPIs are present, dependencies are not satisfied and above plugins are not installed.
WORKDIR /usr/share/jenkins/ref/plugins
RUN wget http://updates.jenkins-ci.org/download/plugins/script-security/1.13/script-security.hpi
RUN wget http://updates.jenkins-ci.org/download/plugins/junit/1.2/junit.hpi
RUN wget http://updates.jenkins-ci.org/download/plugins/matrix-project/1.6/matrix-project.hpi
