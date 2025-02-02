pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-docker-image' // Nama image Docker
        DOCKERFILE_PATH = '/opt/Dockerfile' // Path Dockerfile di VPS
        GO_APP_PATH = '/opt/devops-automation' // Path untuk menaruh kode Go
        REPO_URL = 'https://github.com/kingslyDev/devops-automation.git'
        BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Clone repo ke /opt/devops-automation
                    sh 'git clone -b ${BRANCH} ${REPO_URL} ${GO_APP_PATH} || (cd ${GO_APP_PATH} && git pull origin ${BRANCH})'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image dengan Dockerfile yang ada di /opt
                    sh 'docker build -t ${DOCKER_IMAGE} -f ${DOCKERFILE_PATH} ${GO_APP_PATH}'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run kontainer dari image yang baru dibangun
                    sh 'docker run -d --name my_container -p 8080:8080 ${DOCKER_IMAGE}'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Membersihkan workspace setelah selesai
        }
    }
}
