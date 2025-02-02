pipeline {
    agent any

    environment {
        VPS_DIR = '/opt/devops-automation'
        VPS_IP = '34.101.152.178'
        VPS_USER = 'ghalyallcoc'  // Gantilah dengan nama pengguna VPS Anda
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Melakukan git pull untuk memastikan kita menggunakan branch main
                script {
                    git url: 'https://github.com/kingslyDev/devops-automation.git', branch: 'main'
                }
            }
        }

        stage('Pull to VPS') {
            steps {
                script {
                    // Menggunakan SSH Agent untuk terhubung ke VPS
                    sshagent(credentials: ['vps-ssh-credentials']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} 'git pull https://github.com/kingslyDev/devops-automation.git main && cd ${VPS_DIR}'
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sshagent(credentials: ['vps-ssh-credentials']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} '
                                cd ${VPS_DIR} &&
                                docker build -t app1 .'
                        """
                    }
                }
            }
        }

        stage('Run Docker Image') {
            steps {
                script {
                    sshagent(credentials: ['vps-ssh-credentials']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_IP} '
                                docker run -d -p 8080:8080 --name app1 app1'
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Build pipeline completed.'
        }
    }
}
