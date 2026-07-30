pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }


        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t sample-nodejs:latest .
                '''
            }
        }

    }
}