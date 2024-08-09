pipeline {
    agent any 
        tools { 
        maven "M2_HOME",
            
        jdk 'jdk-22' // Or another supported JDK
    
        
    }   

      environment {
        DOCKERHUB_CREDENTIALS=credentials('dockerhub')
    }
        
       

    stages {

        
        stage('git clone') {
            steps {
               git branch: 'main', url: 'https://github.com/doraaaaaaaaaa/devops-esprit'
        
            }
        }
        stage('clean package') {
            steps {
             sh 'mvn clean install -DskipTests=true'
        
        
            }
        }
        stage('mvn test') {
            steps {
             sh 'mvn test'
        
        
            }
        }
         stage('sonarqube') {
            steps {
            withSonarQubeEnv( 'sonarqube:8.9.7-community') {
                 sh 'mvn verify -DskipTests=true'
                 sh 'mvn sonar:sonar'
   
                }
        
        
            }
        }
        stage('Nexus') {
            steps {
                script{
          nexusPublisher nexusInstanceId: 'nexus3',
                                          nexusRepositoryId: 'Maven-',
                                          packages: [[$class: 'MavenPackage', 
                                          mavenAssetList: [[classifier: '', extension: '', filePath: 'target/achat-1.0.jar']], 
                                          mavenCoordinate: [artifactId: 'achat', groupId: 'com.esprit.examen', packaging: 'jar', version: '1.0']]]      
                }
            }
        } 
           stage('build-image') {
            steps {
                 sh 'ansible-playbook ansible-playbook.yml '
   
            }
        }
        
         stage('push docker hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW'
                //sh 'docker push dorra7/test'
   
            }
        }
           stage(' docker-compose') {
            steps {
                sh 'docker-compose -f docker-compose-app.yml up  -d '
   
            }
        }
 
        
        
    }    
        
        
}
