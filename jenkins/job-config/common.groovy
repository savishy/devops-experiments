def hello() {
  echo "hello"
}

/**
**/
def checkoutGit(repoUrl) {
  git url: "${repoUrl}"
}

/**

**/
def buildWar() {
  sh "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 && ./mvnw install"
}
return this
