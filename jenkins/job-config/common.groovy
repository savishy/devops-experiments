def hello() {
  echo "hello"
}

/**
**/
def checkoutGit(repoUrl) {
  git url: "${repoUrl}"
}

/**
This method builds a war

**/
def buildWar(javaHome,buildCmd) {
  sh "export JAVA_HOME=${javaHome} && ${buildCmd}"
}

/**
BUILD DOCKER IMAGE

Parameters:
- dockerImageName: name with tags of docker image to create.
- dockerWorkspace: relative directory containing a Dockerfile.
- dockerServer: URI for a Docker Daemon Default: tcp://127.0.0.1:2375
**/
def buildDockerImage(
  dockerImageName,
  dockerWorkspace,
  dockerServer = "tcp://127.0.0.1:2375") {

  docker.withServer(dockerServer) {
    docker.build(dockerImageName,dockerWorkspace)
  }

}

/**

references:
http://mrhaki.blogspot.in/2009/04/escaping-quotes-in-groovy-strings.html
https://groups.google.com/forum/#!topic/groovy-user/PAjWvGeu1rs
**/
def getMavenProjectVersion() {

  def cmd = $/./mvnw -q -Dexec.executable="echo" -Dexec.args='$${project.version}' org.codehaus.mojo:exec-maven-plugin:1.3.1:exec/$
  def retVal = sh returnStdOut: true, script: cmd
  return retVal
}

return this
