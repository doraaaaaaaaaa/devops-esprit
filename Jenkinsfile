pipeline {
    agent any

    stages {
        stage('Checkout GIT') {
            steps {
                echo 'Pulling ...'
                git branch: 'main', url: 'https://github.com/doraaaaaaaaaa/devops-esprit.git'
                sh 'git branch -a'
                sh 'git status'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'custom-maven-jdk22'
                    def imageTag = 'latest'
                    
                    // Check if the Docker image exists
                    def imageExists = sh(script: "docker images -q ${imageName}:${imageTag}", returnStatus: true) == 0
                    
                    if (!imageExists) {
                        echo "Docker image ${imageName}:${imageTag} does not exist. Building the image..."
                        sh '''
                        docker build -t ${imageName}:${imageTag} -f Dockerfile .
                        '''
                    } else {
                        echo "Docker image ${imageName}:${imageTag} already exists."
                    }
                }
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
