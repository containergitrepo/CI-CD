pipeline {
  agent any 
  tools {
    maven 'Maven'
  }
  stages {
    stage ('Initialize') {
      steps {
        sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
            ''' 
      }
    }
    stage ('Check-Git-Secrets') {
      steps {
        sshagent(['CICD-Tools']) {
        sh 'ubuntu@3.130.59.82'
        sh 'rm trufflehog || true'
        sh 'docker run gesellix/trufflehog --json https://github.com/containergitrepo/CI-CD.git > trufflehog'
        sh 'cat trufflehog'
        }
      }
    }
    stage ('Build') {
      steps {
      sh 'mvn clean package'
       }
    }
    }
    }
