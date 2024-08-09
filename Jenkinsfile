pipeline {
    agent any

    stages {
        stage('Checkout GIT') {
            steps {
                echo 'Pulling ...'
                git branch: 'main',
                    url: 'https://github.com/doraaaaaaaaaa/stage-devops'
                sh 'git branch -a'
                sh 'git status'
            }
        }
    
        
        
        stage('Testing Maven') {
            steps {
                script {
                    docker.image('custom-maven-jdk22:latest').inside('-v /root/.m2:/root/.m2') {
                        sh 'mvn -version'
                    }
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    docker.image('custom-maven-jdk22:latest').inside('-v /root/.m2:/root/.m2') {
                        sh 'mvn -B -DskipTests clean package'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image('custom-maven-jdk22:latest').inside('-v /root/.m2:/root/.m2') {
                        sh 'mvn test'
                    }
                }
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    }
}
