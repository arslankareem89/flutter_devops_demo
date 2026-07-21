pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/opt/flutter"
        PATH = "${env.FLUTTER_HOME}/bin:${env.PATH}"
        IMAGE_NAME = "flutter-web"
        IMAGE_TAG = "v1"
        CONTAINER_NAME = "flutter-container"
    }

    stages {
        stage('Flutter Version') {
            steps {
                sh '''
                git config --global --add safe.directory /opt/flutter || true
                git config --global --add safe.directory '*' || true
                flutter --version
                '''
            }
        }

        stage('Get Packages') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    export PATH=$PATH:/opt/sonar-scanner/bin
                    sonar-scanner \
                      -Dsonar.projectKey=flutter-devops-demo \
                      -Dsonar.projectName=flutter-devops-demo \
                      -Dsonar.sources=lib \
                      -Dsonar.exclusions=**/*.g.dart,**/*.freezed.dart
                    '''
                }
            }
        }

        stage('Build Flutter Web') {
            steps {
                sh 'flutter build web --release'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG}.'
            }
        }

        stage('Run with Docker Compose') {
            steps {
                sh '''
                docker rm -f ${CONTAINER_NAME} || true
                docker compose down || true
                docker compose up -d --build
                docker ps | grep ${CONTAINER_NAME}
                '''
            }
        }
    }

    post {
        always {
            echo '🎉 Pipeline completed!'
        }
        success {
            echo '✅ Build and deployment successful! App running on port 8080'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
