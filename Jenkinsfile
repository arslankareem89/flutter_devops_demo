pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"
        PATH = "${FLUTTER_HOME}/bin:${env.PATH}"

        IMAGE_NAME = "flutter-web"
        IMAGE_TAG = "v1"

        COMPOSE_PROJECT_NAME = "flutter-devops-demo"
    }

    stages {

        stage('Flutter Version') {
            steps {
                sh '''
                git config --global --add safe.directory /opt/flutter || true
                flutter --version
                '''
            }
        }

        stage('Get Packages') {
            steps {
                sh '''
                flutter pub get
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=flutter-devops-demo \
                          -Dsonar.projectName=flutter-devops-demo \
                          -Dsonar.sources=lib \
                          -Dsonar.host.url=$SONAR_HOST_URL \
                          -Dsonar.token=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Build Flutter Web') {
            steps {
                sh '''
                flutter build web --release
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                docker compose down || true
                docker compose up -d --build
                docker ps
                '''
            }
        }
    }

    post {
        success {
            echo '================================='
            echo 'Build Successful!'
            echo 'Flutter App: http://localhost:8080'
            echo 'SonarQube : http://localhost:9000'
            echo 'Jenkins   : http://localhost:8081'
            echo '================================='
        }

        failure {
            echo 'Pipeline Failed!'
        }

        always {
            echo 'Pipeline Finished'
        }
    }
}
