pipeline {
    agent any
    environment {
        VPS_USER = "ghalyallcoc"
        VPS_HOST = "34.128.112.49"
        SSH_KEY = "/var/lib/jenkins/.ssh/google-cloud-ssh"
        APP_DIR = "/opt/devopsnyoba"
        DOCKER_IMAGE = "devops-automation:latest"
        CONTAINER_NAME = "devops_container"
        PORT = "8080"
        GIT_REPO = "git@github.com:kingslyDev/devops-automation.git"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }
        
        stage('Linting Go Code') {
            steps {
                sh 'go fmt ./...'
            }
        }
        
        stage('Transfer Code to VPS') {
            steps {
                sh """
                scp -i ${SSH_KEY} -o StrictHostKeyChecking=no -r . ${VPS_USER}@${VPS_HOST}:${APP_DIR}
                """
            }
        }

        stage('Build Docker Image on VPS') {
            steps {
                sh """
                ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_HOST} << EOF
                cd ${APP_DIR}
                docker build -t ${DOCKER_IMAGE} .
                EOF
                """
            }
        }

        stage('Deploy Container on VPS') {
            steps {
                sh """
                ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_HOST} << EOF
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker run -d -p ${PORT}:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
                EOF
                """
            }
        }
    }
}
