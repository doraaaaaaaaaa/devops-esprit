
//trivy dast
pipeline {
    agent any

    tools { 
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE = 'dorra7/devops-esprit'
        DOCKER_TAG = 'latest'
        SONAR_CREDENTIALS = credentials('sonar')
    }

    stages {

        stage('GIT Checkout') {
            steps {
                git branch: 'main',
                    changelog: false,
                    credentialsId: 'jenkins-github', 
                    url: 'https://github.com/doraaaaaaaaaa/devops-esprit.git'
            }
        }

        stage('Secret Scan - Gitleaks') {
            steps {
                script {
                    echo "🔍 Running Gitleaks secret scan on the latest commit..."
                    sh 'rm -f gitleaks-report.json'
                    def status = sh(script: "gitleaks detect --source . --commit=HEAD --no-banner --exit-code=1 --report-path=gitleaks-report.json -v", returnStatus: true)
                    if (status != 0) {
                        echo "❌ Secrets detected! Check gitleaks-report.json"
                        error("Pipeline failed: secrets detected by Gitleaks")
                    } else {
                        echo "✅ No secrets found"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn verify -DskipTests=true'
                    sh "mvn sonar:sonar -Dsonar.login=${SONAR_CREDENTIALS}"
                }
            }
        }

        stage('Maven Build') {
            steps {
                echo '📦 Compilation du projet avec Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Build Docker image...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Run Application for DAST') {
            steps {
                echo '🚀 Lancement du conteneur pour DAST...'
                sh 'docker run -d --name myapp -p 8080:8080 ${DOCKER_IMAGE}:${DOCKER_TAG}'
                // Optionnel: attendre quelques secondes pour que l'app démarre
                sh 'sleep 10'
            }
        }

        stage('Trivy DAST Scan') {
            steps {
                echo '🔎 Scan dynamique avec Trivy...'
                sh '''
                    trivy http --scanners vuln,config,secret --severity HIGH,CRITICAL http://localhost:8080 \
                        --output trivy-dast-report.json --format json
                    echo "✅ Trivy DAST report generated: trivy-dast-report.json"
                '''
            }
        }

        stage('Stop Application') {
            steps {
                echo '🛑 Arrêt du conteneur...'
                sh '''
                    docker stop myapp
                    docker rm myapp
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo '🔐 Login to Docker Hub and push image...'
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline terminée avec succès !"
        }
        failure {
            echo "❌ La pipeline a échoué."
        }
    }
}
