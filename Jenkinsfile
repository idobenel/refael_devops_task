pipeline {

    agent any

    environment {
        IMAGE_NAME = "sample-nodejs"
    }

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

        stage('Version Bump') {
            steps {
                sh '''
                    npm version patch --no-git-tag-version
                '''
            }
        }

        stage('SAST - Semgrep') {
            steps {
                sh '''
                    semgrep \
                    --config auto \
                    --error \
                    .
                '''
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def version = sh(
                        script: "node -p \"require('./package.json').version\"",
                        returnStdout: true
                    ).trim()

                    sh """
                        docker build \
                        -t ${IMAGE_NAME}:${version} \
                        -t ${IMAGE_NAME}:latest \
                        .
                    """
                }
            }
        }

    }
}