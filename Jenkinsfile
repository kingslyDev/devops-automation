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
        WORK_DIR = "${WORKSPACE}/repo"
    }
    stages {
        stage('Checkout Code') {
            steps {
                sh """
                export GIT_SSH_COMMAND='ssh -i /var/lib/jenkins/.ssh/id_rsa -o StrictHostKeyChecking=no'
                
                if [ -d "${WORK_DIR}" ]; then
                    echo "Directory ${WORK_DIR} exists. Pulling latest changes..."
                    cd ${WORK_DIR}
                    git reset --hard
                    git clean -fd
                    git pull origin main
                else
                    echo "Cloning repository fresh..."
                    git clone ${GIT_REPO} ${WORK_DIR}
                    cd ${WORK_DIR}
                    git checkout main
                fi
                """
            }
        }

        stage('Transfer Code to VPS') {
            steps {
                sh """
                scp -q -i ${SSH_KEY} -o StrictHostKeyChecking=no -r ${WORK_DIR}/* ${VPS_USER}@${VPS_HOST}:${APP_DIR}/
                ssh -q -i ${SSH_KEY} -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_HOST} "chmod -R 775 ${APP_DIR}"
                """
            }
        }

        stage('Build Docker Image on VPS') {
            steps {
                sh """
                ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_HOST} "cd ${APP_DIR} && docker build --no-cache --rm -t ${DOCKER_IMAGE} ."
                """
            }
        }

        stage('Deploy Container on VPS') {
            steps {
                sh """
                ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_HOST} "
                if [ \$(docker ps -aq --filter name=${CONTAINER_NAME}) ]; then
                    echo 'Stopping and removing existing container ${CONTAINER_NAME}...'
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                fi

                echo 'Starting new container ${CONTAINER_NAME}...'
                docker run -d -p ${PORT}:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
                "
                """
            }
        }
    }
}
