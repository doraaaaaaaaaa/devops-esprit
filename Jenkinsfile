pipeline {
    agent any

    tools { 
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub'),
        SONAR_CREDENTIALS = credentials('sonar')
        // NEXUS_CREDENTIALS = credentials('nexus')
    }

    stages {
        stage('Git Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/doraaaaaaaaaa/devops-esprit'
            }
        }

        stage('Clean and Package') {
            steps {
                sh 'mvn clean install -DskipTests=true -U'

            }
        }

        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube') {
            steps {
                withSonarQubeEnv('sonarqube:8.9.7-community') {
                    sh 'mvn verify -DskipTests=true'
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Nexus') {
            steps {
                script {
                    nexusPublisher(
                        nexusInstanceId: 'nexus3',
                        nexusRepositoryId: 'Maven-',
                        packages: [
                            [
                                $class: 'MavenPackage',
                                mavenAssetList: [
                                    [
                                        classifier: '',
                                        extension: '',
                                        filePath: 'target/achat-1.0.jar'
                                    ]
                                ],
                                mavenCoordinate: [
                                    artifactId: 'achat',
                                    groupId: 'com.esprit.examen',
                                    packaging: 'jar',
                                    version: '1.0'
                                ]
                            ]
                        ]
                    )
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'ansible-playbook ansible-playbook.yml'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Logging in to Docker Hub
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    
                    // Push Docker image
                    // Uncomment and set the correct image name
                    // sh 'docker push your-dockerhub-username/your-image-name'
                }
            }
        }

        stage('Docker Compose') {
            steps {
                sh 'docker-compose -f docker-compose-app.yml up -d'
            }
        }
    }
}
