pipeline {
    agent any

    environment {
        CLEANUP_SCRIPT = "clean-up.sh"
    }

    stages {
        stage('Initial Cleanup') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE')
                    sh """
                        echo "#!/bin/bash" > ${CLEANUP_SCRIPT}
                        echo "echo Cleaning up Docker containers and images..." >> ${CLEANUP_SCRIPT}
                        echo "docker rm -f \$(docker ps -aq)" >> ${CLEANUP_SCRIPT}
                        echo "docker rmi -f \$(docker images -aq)" >> ${CLEANUP_SCRIPT}
                        echo "docker rm -f \$(docker ps -aq)" >> ${CLEANUP_SCRIPT}
                        echo "docker rmi -f \$(docker images -aq)" >> ${CLEANUP_SCRIPT}
                        chmod +x ${CLEANUP_SCRIPT}
                        ./${CLEANUP_SCRIPT}
                    """
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    chmod +x Dockerfile
                    cd nginx && chmod +x Dockerfile && docker build -t nginx-reverse-proxy .
                    cd .. && docker build -t flask-app .
                """
            }
        }

        stage('Docker Run') {
            steps {
                sh """
                    cd nginx && docker run -d -p 80:80 nginx-reverse-proxy
                    cd .. && docker run -d -p 5500:80 -e YOUR_NAME='Tom' flask-app
                """
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
            archiveArtifacts artifacts: 'clean-up.sh', fingerprint: true
            echo 'Cleanup script executed and archived.'
        }
    }
}