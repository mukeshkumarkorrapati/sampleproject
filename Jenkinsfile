pipeline {
    agent any
    tools {
        jdk 'jdk-17'
        maven 'maven3'
    } 
    environment {
       SONAR_HOME= tool 'SonarQube'
       DOCKER_REPO= 'mukeshjava92/boardgame'
    }

    stages {
        stage('Clean Workspace') { 
            steps { 
                cleanWs()
                 }
        }
        stage('Source code checkout') {
            steps {
                git branch:'main',credentialsId:'docker-cred',url:'https://github.com/mukeshjava92/Boardgame.git'
            }
        }
        stage('Unit Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('File System scan') {
            steps {
                sh " trivy fs --format table -o FS-trivy.html ."
            }
        }
        stage('SonarQube Quality analysis') {
            steps {
               withSonarQubeEnv('SonarQube'){
                   sh ''' $SONAR_HOME/bin/sonar-scanner -Dsonar.url=http://43.204.147.188:9000/ -Dsonar.projectName=Boardgame -Dsonar.projectKey=Boardgame -Dsonar.java.binaries=.
                   '''
               }
            }
        }
        stage('Sonar Quatity Gate') {
            steps {
                script {
                waitForQualityGate abortPipeline: true, credentialsId: 'sonarqube'
            }
          }
        }
        stage('Build') {
            steps {
                sh "mvn clean package"
            }
        }  
        stage('Docker Image Build'){
            steps {
                sh "docker build -t ${env.DOCKER_REPO}:${env.BUILD_ID} ."
            }
        }   
        stage('Image push to docker registry') {
            steps {
                withDockerRegistry([credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/']) {
                  sh "docker push ${env.DOCKER_REPO}:${env.BUILD_ID}"
               }
            }
        }   
       stage('Deploy'){
            steps {
                sh "docker run -dt --name boardgame -p 8081:8080 ${DOCKER_REPO}:${env.BUILD_ID}"
            }
        }      
    }
}
