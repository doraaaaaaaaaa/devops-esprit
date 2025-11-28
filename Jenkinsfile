
//test webhook 
pipeline {
    agent any

    tools { 
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')   // Docker Hub credentials
        DOCKER_IMAGE = 'dorra7/devops-esprit'              // Nom du repo Docker Hub
        DOCKER_TAG = 'latest'                              // Tag Docker
        SONAR_CREDENTIALS = credentials('sonar')          // Token SonarQube
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


stage('Secrets Scan - Gitleaks') {
    steps {
        echo "🕵️‍♂️ Scanning for exposed secrets..."
        sh '''
        # Lancer le scan avec Gitleaks
        gitleaks detect --source=. --no-git --report-format=json --report-path=gitleaks-report.json

        # Vérifier le nombre de secrets détectés
        if command -v jq >/dev/null 2>&1; then
            leaks=$(jq 'length' gitleaks-report.json)
            if [ "$leaks" -gt 0 ]; then
                echo "⚠️ Gitleaks found $leaks potential secrets. Check gitleaks-report.json"
                exit 1
            else
                echo "✅ No secrets found by Gitleaks!"
            fi
        else
            echo "⚠️ jq not installed, skipping leak count check."
        fi
        '''
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

stage('Trivy Scan') {
            steps {
                echo '🔎 Scan de sécurité complet du projet avec Trivy...'
                sh '''
                    set -e
                    echo "📁 Démarrage du scan Trivy (config + dépendances + secrets)..."

                    # Lancer le scan Trivy sur tout le projet
                    trivy fs . \
                        --scanners vuln,config,secret \
                        --severity HIGH,CRITICAL \
                        --ignore-unfixed \
                        --no-progress \
                        --format json \
                        --output trivy-full-report.json

                    echo "✅ Scan terminé. Rapport généré : trivy-full-report.json"
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
