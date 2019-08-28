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
        sh 'rm trufflehog || true'
        sh 'docker run gesellix/trufflehog --json https://github.com/containergitrepo/CI-CD.git > trufflehog'
        sh 'cat trufflehog'
        }
      }
    
    stage ('Source Composition Analysis') {
      steps {
         sh 'rm owasp* || true'
         sh 'wget "https://raw.githubusercontent.com/containergitrepo/CI-CD/master/owasp-dependency-check.sh" '
         sh 'chmod +x owasp-dependency-check.sh'
         sh 'bash owasp-dependency-check.sh'
         sh 'cat /var/lib/jenkins/OWASP-Dependency-Check/reports/dependency-check-report.xml'
        
      }
    }
    
    stage ('SAST') {
      steps {
        withSonarQubeEnv('sonar') {
          sh 'mvn clean package sonar:sonar'
          sh 'cat target/sonar/report-task.txt'
        }
      }
    }
    
    stage ('Build') {
      steps {
      sh 'mvn clean package'
       }
    }
    stage('Unit Testing and Code Coverage') {
      steps {
      junit 'target/surefire-reports/*.xml'
      step( [ $class: 'JacocoPublisher' ] )
  } 
    }
      stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("123321bha/todoapp")
                }
            }
        }
    
    stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
     stage('analyze') {
            steps {
                sh 'echo "docker.io/123321bha/todoapp `pwd`/Dockerfile" > anchore_images || true'
                anchore name: 'anchore_images'
            }
        }
    }
    }
    
