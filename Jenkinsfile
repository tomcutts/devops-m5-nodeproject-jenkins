pipeline {
    agent any
    options {
        timestamps()
         }
    //environment {
       // CLEANUP_SCRIPT = "clean-up.sh"
  //  }

    stages {
        stage('Initial Cleanup & Create Custom Network') {
            steps {
                script {
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                    sh "echo Cleaning up Docker containers and images..."
                    sh "docker rm -f flask-app-hello"
                    sh "docker rmi -f flask-app"
                    sh "docker rm -f nginx-reverse-proxy"
                    sh "docker rmi -f nginx-reverse-proxy"
                    sh "docker network create custom-network || true"
                    }
                }
            }
        }

        stage('Docker build flask-app') {
            steps {
                script {
                    sh "echo Building and running flask-app"
                    sh "chmod +x Dockerfile"
                    sh "docker build -t flask-app ."
                  
                }
            }
        }

        stage('Docker build nginx') {
            steps {
                script {
                // Navigate to the nginx directory
                    dir('nginx') {
                        sh "echo building and running nginx"
                        sh "chmod +x Dockerfile"
                        sh "docker build -t nginx-reverse-proxy ."

                    }
                }
            }
        }

        stage('Run security scans...') {
            steps {
                script {
                // Run security scans with Trivy
                    sh '''
                        trivy image --severity CRITICAL,HIGH --exit-code 0 --format table --output trivy-flask.txt flask-app
                        trivy image --severity CRITICAL,HIGH --exit-code 0 --format table --output trivy-nginx.txt nginx-reverse-proxy
                    '''
                }
                post {
                    always {
                        archiveArtifacts artifacts: 'trivy-*.txt', fingerprint: true
                }
                    failure {
                        echo "X Vunerabilities detected - blocking the pipeline"
                }
            }
        }
    }

        stage('Docker run containers') {
            steps {
                script {
                    sh "docker run --name nginx-reverse-proxy --network custom-network -d -p 80:80 nginx-reverse-proxy"
                    sh "docker run --name flask-app-hello --network custom-network -d -p 5500:80 -e YOUR_NAME='Tom' flask-app"
                    sh "docker ps -a"
                  
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    dir('tests') {
                        sh '''
                            python3 -m venv venv
                            . venv/bin/activate
                            pip install -r ../requirements.txt
                            python3 -m xmlrunner discover -s . -o test-reports
                        '''
                    }
                }
            }
            post {
                always {
                    junit 'tests/test-reports/**/*.xml'
                    archiveArtifacts artifacts: 'tests/test-reports/**/*.xml', fingerprint: true
                }
            }
        }

    post {
        always {
            echo "Pipeline completed."
        }
    }
}