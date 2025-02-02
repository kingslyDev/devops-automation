pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops-automation'
        DOCKER_TAG = 'latest'
        REMOTE_SERVER = 'ghalyallcoc@34.128.112.49' // Ganti dengan IP VPS Anda
    }

    stages {x`
        stage('Checkout') {
            steps {
                git 'https://github.com/kingslyDev/devops-automation.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker tag $DOCKER_IMAGE:$DOCKER_TAG kingslydev/$DOCKER_IMAGE:$DOCKER_TAG'
                    sh 'docker push kingslydev/$DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Stop & Remove Existing Container') {
            steps {
                script {
                    sshagent(['vps-ssh-credentials']) {
                        sh 'ssh -o StrictHostKeyChecking=no $REMOTE_SERVER "docker ps -q -f name=devops-automation | xargs -r docker stop | xargs -r docker rm"'
                    }
                }
            }
        }

        stage('Deploy New Container') {
            steps {
                script {
                    sshagent(['vps-ssh-credentials']) {
                        sh 'ssh -o StrictHostKeyChecking=no $REMOTE_SERVER "docker run -d --name devops-automation -p 8080:8080 kingslydev/$DOCKER_IMAGE:$DOCKER_TAG"'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
