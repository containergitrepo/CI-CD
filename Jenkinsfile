pipeline {
  agent any 
  tools {
    maven 'Maven'
  }
  environment {
        //be sure to replace "willbla" with your own Docker Hub username
        DOCKER_IMAGE_NAME = "123321bha/todoapp"
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
    
    stage ('SAST Analysis') {
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
    
    stage ('DAST Analysis') {
      steps {
      sh 'rm /tomcat/apache-tomcat-8.5.45/webapps/todoApp.jar || true'
      sh 'rm /var/lib/jenkins/workspace/CICD-DevSecOps-Pipeline/target/todoApp.jar.original'
      sh 'cp /var/lib/jenkins/workspace/CICD-DevSecOps-Pipeline/target/todoApp.jar /tomcat/apache-tomcat-8.5.45/webapps/'
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
     stage('Scanning the Image') {
            steps {
                sh 'echo "docker.io/123321bha/todoapp `pwd`/Dockerfile" > anchore_images || true'
                anchore name: 'anchore_images', bailOnFail: false, bailOnPluginFail: false
                sh'''
                    for i in `cat anchore_images | awk '{print $1}'`;do docker rmi $i; done
                '''
            }
        }
    
    stage('Deploy To Production') {
            steps {
                kubernetesDeploy(
                    kubeconfigId: 'kubeconfig',
                    configs: 'todo-kube.yml',
                    enableConfigSubstitution: true
                )
            }
        }
    }
    }
    
