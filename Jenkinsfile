
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

        /*stage('Secret Scan') {
            steps {
                script {
                    echo "🔍 Running Gitleaks secret scan on the latest commit only..."
                    sh 'rm -f gitleaks-report.json'
                    def status = sh(script: "gitleaks detect --source . --commit=HEAD --no-banner --exit-code=1 --report-path=gitleaks-report.json -v", returnStatus: true)
                    
                    if (status != 0) {
                        echo "❌ Secrets detected in the latest commit! Check gitleaks-report.json for details."
                    } else {
                        echo "✅ No secrets found in the latest commit."
                    }
                }
            }
        }*/


    stage('Secret Scan') {
    steps {
        script {
            echo "🔍 Running Gitleaks secret scan on the latest commit only..."
            
            // Supprime l'ancien rapport pour éviter faux positif
            sh 'rm -f gitleaks-report.json'

            // Scanner uniquement le dernier commit
            def status = sh(script: "gitleaks detect --source . --commit=HEAD --no-banner --exit-code=1 --report-path=gitleaks-report.json -v", returnStatus: true)
            
            if (status != 0) {
                echo "❌ Secrets detected in the latest commit! Check gitleaks-report.json for details."
                // Pour ne pas arrêter le pipeline, on commente la ligne error()
                 error("❌ Secrets detected by Gitleaks!")
            } else {
                echo "✅ No secrets found in the latest commit."
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
