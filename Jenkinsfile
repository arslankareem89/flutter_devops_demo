pipeline {
    agent {
        docker {
            image 'ghcr.io/cirruslabs/flutter:stable'
            args '-u root'
        }
    }

    stages {
        stage('Flutter Version') {
            steps {
                sh 'flutter --version'
            }
        }

        stage('Build Flutter Web') {
            steps {
                sh 'flutter pub get'
                sh 'flutter build web'
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
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
