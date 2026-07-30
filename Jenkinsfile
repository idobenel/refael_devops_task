pipeline {

    agent any

    environment {
        APP_NAME = "sample-nodejs"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        stage('Version Bump') {
            steps {
                sh '''
                    npm version patch
                '''
            }
        }


        stage('Build') {
            steps {
                sh '''
                    npm install
                '''
            }
        }

    }
}