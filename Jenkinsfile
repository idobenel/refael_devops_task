pipeline {

    agent any

    environment {
        IMAGE_NAME = "sample-nodejs"
        IMAGE_VERSION = ""
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
                    --severity ERROR \
                    .
                '''
            }
        }

        stage('Docker Build') {
            steps {
                script {

                    IMAGE_VERSION = sh(
                        script: "node -p \"require('./package.json').version\"",
                        returnStdout: true
                    ).trim()

                    sh """
                        docker build \
                        -t ${IMAGE_NAME}:${IMAGE_VERSION} \
                        -t ${IMAGE_NAME}:latest \
                        .
                    """
                }
            }
        }

        stage('Docker Image Scan - Trivy') {
            steps {
                sh """
                    trivy image \
                    --severity HIGH,CRITICAL \
                    --ignorefile .trivyignore \
                    --exit-code 1 \
                    ${IMAGE_NAME}:${IMAGE_VERSION}
                """
            }
        }

    }
}