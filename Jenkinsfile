pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
    }

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
                sh 'npm ci'
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
                    def imageVersion = sh(
                        script: "node -p \"require('./package.json').version\"",
                        returnStdout: true
                    ).trim()
                    env.IMAGE_VERSION = imageVersion

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

        stage('Load Image to Kind') {
            steps {
                sh """
                    kind load docker-image ${IMAGE_NAME}:${IMAGE_VERSION} --name devops-task
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    helm upgrade --install sample-nodejs \
                    ./helm/sample-nodejs \
                    --set image.repository=${IMAGE_NAME} \
                    --set image.tag=${IMAGE_VERSION}
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                sh """
                    kubectl rollout status deployment/sample-nodejs-sample-nodejs --timeout=180s
                    kubectl get pods
                """
            }
        }

    }


    post {
        failure {
            sh '''
                echo "Deployment failed - collecting Kubernetes diagnostics"
                kubectl get pods || true
                kubectl describe pods || true
                kubectl get events --sort-by=.metadata.creationTimestamp || true
            '''
        }

    }
}