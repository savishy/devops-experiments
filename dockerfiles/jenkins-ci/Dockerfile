FROM ubuntu:16.04

# install common packages
RUN apt-get update -qqy
RUN apt-get install -y wget software-properties-common curl

# env vars
ENV JENKINS_HOME /var/lib/jenkins
ENV JAVA_OPTS "-Djava.awt.headless=true -Dhudson.diyChunking=false"
ENV JENKINS_OPTS "--httpPort=8080"
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
COPY credentials.xml  $JENKINS_HOME
COPY org.jenkinsci.plugins.dockerbuildstep.DockerBuilder.xml $JENKINS_HOME

# Add Jenkins Plugins list
COPY plugins.txt $JENKINS_HOME/plugins.txt
COPY plugin.sh $JENKINS_HOME/plugin.sh
WORKDIR $JENKINS_HOME
RUN sh -c "$JENKINS_HOME/plugin.sh $JENKINS_HOME/plugins.txt"

# download and run plugin.sh script
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh)" /var/lib/jenkins/plugins.txt

# prevent jenkins from showing "unlock jenkins" dialog.
RUN echo 2.7.1 > $JENKINS_HOME/ref/jenkins.install.InstallUtil.lastExecVersion

# unless these HPIs are present, dependencies are not satisfied and above plugins are not installed.
#WORKDIR /var/lib/jenkins/ref/plugins
#RUN wget http://updates.jenkins-ci.org/download/plugins/script-security/1.13/script-security.hpi
#RUN wget http://updates.jenkins-ci.org/download/plugins/junit/1.2/junit.hpi
#RUN wget http://updates.jenkins-ci.org/download/plugins/matrix-project/1.6/matrix-project.hpi

CMD exec java $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS
