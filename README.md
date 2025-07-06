# Secure DevOps EKS Project

This project demonstrates a production-grade DevOps pipeline and infrastructure on AWS using EKS, Terraform, GitHub Actions, Helm, and open-source security tools.

## 🚀 Project Overview

A secure, automated deployment pipeline for containerized applications using:

- **Amazon EKS** for Kubernetes orchestration
- **Terraform** for infrastructure as code (IaC)
- **GitHub Actions** for CI/CD pipelines
- **Helm** for Kubernetes application deployment
- **AWS ALB Ingress Controller** for external access
- **ECR** for container image storage
- **CloudWatch Logs** for centralized logging
- **Trivy**, **tfsec**, and **kube-bench** for security scanning

---

## 🛠️ Features Implemented

### 🔹 Infrastructure

- VPC with public and private subnets
- EKS Cluster with managed node group
- Secure IAM roles with GitHub OIDC integration
- ALB Ingress Controller for public app access
- S3 + DynamoDB backend for Terraform state

### 🔹 CI/CD Pipeline

- `infra.yml`: Deploys infrastructure using Terraform
- `deploy.yml`: Builds and pushes Docker image, deploys to EKS with Helm

### 🔹 Security

- `tfsec`: Terraform static analysis in CI
- `trivy`: Docker image scanning
- `kube-bench`: Kubernetes CIS benchmark scanner (in progress)
- Private ECR repository
- IAM least-privilege role assumption

---

## 📦 Project Structure
├── backend/ # Terraform bootstrap for S3 + OIDC
├── terraform/ # Main Terraform EKS infrastructure
├── testapp/ # Sample Node.js app with Helm chart
├── .github/workflows/ # CI/CD workflows

## 🧪 How It Works

1. **Terraform** provisions AWS resources, including EKS and IAM OIDC setup.
2. **GitHub Actions** assumes an IAM role using OIDC to deploy infrastructure and application.
3. **Docker image** is built and pushed to ECR.
4. **Helm** deploys the app to EKS with an ALB Ingress.
5. **Security scanners** are triggered in CI/CD for best practices and vulnerability checks.

---

## 🌐 Public Access

Once deployed, the app is publicly accessible via the ALB Ingress URL provisioned by AWS. The ALB is internet-facing with health checks configured.

---

## 🔒 Security Enhancements (Coming Soon)

- Full `kube-bench` scan output integration
- AWS WAF protection on ALB
- Prometheus + Grafana stack for monitoring

---

## 📌 Notes

> ⚠️ This project is tied to a personal AWS account. Infrastructure provisioning is intended for demonstration and learning purposes only. Forking this repo will require adjustments to use your own AWS resources, credentials, and configuration.

---

## 📄 License

MIT