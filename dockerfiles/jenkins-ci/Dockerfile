FROM jenkins:2.7.1
# TODO jenkins security
#ENV JENKINS_OPTS --httpPort=-1 --httpsPort=8083 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk
ENV JENKINS_OPTS --httpPort=8081
ADD plugins.txt /usr/share/jenkins/ref/plugins.txt

# create job config
USER jenkins
RUN mkdir -p /var/jenkins_home/jobs/petclinic-build/
# copy job config as root (no other way)

ADD config.xml /var/jenkins_home/jobs/petclinic-build/config.xml

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

