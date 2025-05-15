pipeline-build-test1{
    agent { node { label 'Built-In Node' } } 

    environment {
        CLEANUP_SCRIPT = "clean-up.sh"
    }

    stages {
        stage('Initial Cleanup') {
            steps {
                script {
                    // Create the cleanup script
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

        // Example next stage
        stage('Docker Build') {
            steps {
               sh """
               chmod +x Dockerfile
               docker build
               """
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
