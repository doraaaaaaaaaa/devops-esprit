pipeline {
    agent any

    stages {
        stage('Checkout GIT') {
            steps {
                echo 'Pulling ...'
                git branch: 'main',
                    url: 'https://github.com/doraaaaaaaaaa/stage-devops'
                sh 'pwd'              // Print the working directory
                sh 'ls -la'           // List all files to ensure Dockerfile is present
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def customImage = 'custom-maven-jdk22:latest'
                    echo 'Building Docker image...'
                    sh 'docker build -t ${customImage} .'
                }
            }
        }

        stage('Testing Maven') {
            steps {
                script {
                    def customImage = 'custom-maven-jdk22:latest'
                    echo 'Running Maven version check inside Docker container...'
                    docker.image(customImage).inside {
                        sh 'mvn -version'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    def customImage = 'custom-maven-jdk22:latest'
                    echo 'Building the project inside Docker container...'
                    docker.image(customImage).inside {
                        sh 'mvn -B -DskipTests clean package'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def customImage = 'custom-maven-jdk22:latest'
                    echo 'Running tests inside Docker container...'
                    docker.image(customImage).inside {
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

    post {
        always {
            echo 'Cleaning up Docker images...'
            sh 'docker system prune -f'
        }
    }
}
