pipeline {
    agent any

    stages {

        stage('Flutter Version') {
            steps {
                sh '/opt/flutter/bin/flutter --version'
            }
        }

        stage('Get Packages') {
            steps {
                sh '''
                git config --global --add safe.directory /opt/flutter
                /opt/flutter/bin/flutter pub get
                '''
            }
        }

        stage('Build Flutter Web') {
            steps {
                sh '/opt/flutter/bin/flutter build web'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t flutter-web:v1 .'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                docker rm -f flutter-container || true
                docker run -d --name flutter-container -p 8080:80 flutter-web:v1
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline completed successfully!'
        }

        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
