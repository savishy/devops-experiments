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

def archiveArtifacts(expression) {

}
return this
