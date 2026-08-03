# DevOps Sample Node.js App

## Overview
A lightweight Node.js application deployed on Kubernetes using Helm.
The project demonstrates CI/CD and DevSecOps practices including automated testing,
SAST scanning, container vulnerability scanning, Docker image creation, and Kubernetes deployment.


## Features
- Express.js web server
- Readiness and liveness probe endpoints
- Customizable port via environment variable


## Prerequisites
- Docker
- Kubernetes cluster
- Helm 3.x
- kubectl
- Node.js v22+
- Jenkins (required only for running the provided CI pipeline)


## Running locally
1. Create KIND cluster:
   kind create cluster --name devops-task
2. Build Docker image:
   docker build -t sample-nodejs:test .
3. Load image into KIND:
   kind load docker-image sample-nodejs:test --name devops-task
4. Deploy using Helm:
   helm upgrade --install sample-nodejs ./helm/sample-nodejs \
   --set image.tag=test
5. Verify deployment:
   kubectl get pods
   kubectl get ingress
6. Add hosts entry:
   127.0.0.1 sample-nodejs.local
7. Access:
   http://sample-nodejs.local


## CI/CD pipeline
The pipeline contains the following stages:
1. Checkout source code
2. Install dependencies
3. Run tests
4. Increment application version
5. Run SAST scan using Semgrep
6. Build Docker image
7. Scan Docker image using Trivy
8. Load image into KIND cluster
9. Deploy using Helm
10. Verify Kubernetes rollout


## Repository Structure
├── app.js
├── Dockerfile
├── helm
|    └── sample-nodejs
|       ├── Chart.yaml
|       ├── templates
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   └── ingress.yaml
|       └── values.yaml
├── Jenkinsfile
├── kind-config.yaml
├── package.json
├── package-lock.json
└── README.md


## Kubernetes Access
The Jenkins container requires access to a Kubernetes kubeconfig.
For the local KIND setup used in this challenge, Jenkins accesses the Kubernetes API through the KIND Docker network.
This allows the pipeline to execute Helm deployments and Kubernetes validation stages from inside the Jenkins container.


## Architecture
Developer
   |
   v
Git Repository
   |
   v
Jenkins Pipeline
   |
   +--> npm install
   |
   +--> npm test
   |
   +--> Version Bump
   |
   +--> Semgrep (SAST)
   |
   +--> Docker Build
   |
   +--> Trivy Image Scan
   |
   +--> kind load docker-image
   |
   +--> Helm
          |
          +--> Deployment
          +--> Service
          +--> Ingress
          |
          +--> Rollout Verification


## Versioning strategy:
During the CI process, the pipeline automatically increments the patch version
inside the build workspace and uses this version as the Docker image tag.
For this challenge, the version bump is used only for the build artifact
and is not committed back to the repository.
In a production environment, this can be extended with a Git tagging strategy
or a release management workflow.

Example:
sample-nodejs:1.0.1


## Docker Image
The application is built using a multi-stage Dockerfile:
- Builder stage installs dependencies and prepares the application.
- Runtime stage contains only the files required for application execution.
- The container runs using a non-root user.


## Trivy Ignore
The pipeline blocks deployment when HIGH or CRITICAL vulnerabilities are detected.
A limited exception exists for vulnerabilities originating from
transitive dependencies that are not used directly by the application runtime.
The exception is documented in `.trivyignore`.


## Kubernetes Deployment
The application is deployed using a Helm chart.
The chart includes:
- Deployment resource
- ClusterIP Service
- NGINX Ingress
- Readiness probe
- Liveness probe
- CPU and memory requests/limits
- Configurable image repository and tag


## Choosing ClusterIP Service
The application is accessed internally through Kubernetes Service and externally through Ingress.
Therefore ClusterIP was selected as the appropriate service type.


## Choosing Deployment over StatefulSet
The application is stateless and does not require stable network identities or persistent storage. 
Therefore Kubernetes Deployment was selected.


## Why Helm?
Helm allows parameterized Kubernetes manifests and simplifies versioned deployments.


## Image Distribution Strategy
The challenge was executed on a local KIND cluster.
Therefore, the pipeline loads the Docker image directly into KIND using kind load docker-image.
In a production environment, the image would be pushed to a private container registry
and Kubernetes would pull the image from the registry.


## GitOps / ArgoCD
For this challenge, direct Helm deployment from the CI pipeline was selected.
In a production environment, this can be implemented by using ArgoCD with a separate GitOps repository,
where Kubernetes manifests are synchronized declaratively.


## Validation
The deployment was validated by:
- Successful Kubernetes rollout
- Running pod status
- Application access through NGINX Ingress
- 
Example:
kubectl get pods
NAME                                      READY   STATUS
sample-nodejs-sample-nodejs-xxxxx        1/1     Running

Application endpoint:
http://sample-nodejs.local/my-app