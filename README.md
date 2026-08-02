# DevOps Sample Node.js App

## Overview

A lightweight Node.js application. It features basic web endpoints, Prometheus metrics integration, and is designed for Kubernetes deployment and CI/CD pipeline demonstrations.

## Features

- Express.js web server
- Prometheus metrics integration
- Readiness and liveness probe endpoints
- Customizable port via environment variable

## Prerequisites

- Node.js (v22.1.0)


## Versioning strategy:
- Application version is managed using Git tags.
- Every release is associated with a semantic version.
- Docker images are tagged using the same version.

## Trivy Ignore
Trivy is configured to fail builds on HIGH and CRITICAL vulnerabilities.
One exception exists for CVE-2026-14257, which originates from npm bundled in the official Node image and is not used by the application runtime.



# StatefulSet vs Deployment
"Due to scope constraints, I used Helm deployment from Jenkins. In production I would separate deployment state into a GitOps repository managed by ArgoCD."