pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops-automation'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout kode dari GitHub
                git 'https://github.com/kingslyDev/devops-automation.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Membangun Docker image dari Dockerfile
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Stop & Remove Existing Container') {
            steps {
                script {
                    // Stop dan hapus kontainer lama jika ada
                    sh 'docker ps -q -f name=$DOCKER_IMAGE | xargs -r docker stop | xargs -r docker rm'
                }
            }
        }

        stage('Deploy New Container') {
            steps {
                script {
                    // Jalankan kontainer baru
                    sh 'docker run -d --name $DOCKER_IMAGE -p 8080:8080 $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment berhasil!'
        }
        failure {
            echo 'Ada yang salah dengan deployment.'
        }
    }
}
