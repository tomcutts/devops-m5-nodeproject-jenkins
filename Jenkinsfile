pipeline {
    agent any
    options {
        timestamps()
         }
    //environment {
       // CLEANUP_SCRIPT = "clean-up.sh"
  //  }

    stages {
        stage('Initial Cleanup') {
            steps {
                script {
                    catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE'){
                    sh "echo Cleaning up Docker containers and images..."
                    sh "docker rm -f flask-app"
                    sh "docker rmi -f flask-app"
                    sh "docker rm -f nginx-reverse-proxy"
                    sh "docker rmi -f nginx-reverse-proxy"
                    }
                }
            }
        }

        stage('Docker build & run flask-app') {
            steps {
                script {
                    sh "echo Building and running flask-app"
                    sh "chmod +x Dockerfile"
                    sh "docker build -t flask-app ."
                    sh "docker run --name flask-app-hello -d -p 5500:80 -e YOUR_NAME='Tom' flask-app"
                    sh "docker ps -a"
                  
                }
            }
        }

        stage('Docker build & run nginx') {
            steps {
                script {
                // Navigate to the nginx directory
                    dir('nginx') {
                        sh "echo building and running nginx"
                        sh "chmod +x Dockerfile"
                        sh "docker build -t nginx-reverse-proxy ."
                        sh "docker run --name nginx-reverse-proxy -d -p 80:80 nginx-reverse-proxy"
                        sh "docker ps -a"
                  
                }
            }
        }
    }
}

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}