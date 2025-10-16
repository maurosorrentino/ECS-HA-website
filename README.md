## Project Summary
This project demonstrates a production-grade, high-availability web infrastructure on AWS, fully automated using Terraform and GitHub Actions.
It showcases skills in cloud architecture, Infrastructure as Code, CI/CD pipelines, container orchestration (ECS), and AWS best practices for scalability, security, and cost efficiency.

![Architecture Diagram](architecture.jpg)

This project showcases a highly available, scalable, and secure AWS architecture, fully provisioned using Terraform.
It demonstrates cloud infrastructure engineering best practices for a real-world production-grade environment.

The stack includes ECS, EC2 Auto Scaling, ALBs, RDS, CloudFront, Route 53, ACM, S3, and KMS, designed for fault tolerance, performance, and maintainability.

## Terraform Setup

1. Bootstrap (Manual Step)

The terraform-bootstrap/ directory contains Terraform code to:

- Create an S3 bucket to store the Terraform remote state
- Configure the necessary IAM permissions for GitHub Actions

⚠️ Important:
This directory must be run manually once before using the GitHub pipelines.
After bootstrap, all other Terraform operations are automated via CI/CD.

⚠️ Security Note:
When the repository was made public, all GitHub Actions IAM permissions were revoked to prevent unauthorized access to AWS.
From this point onward, Terraform is executed manually via the terminal to maintain full security control.

2. Pipelines
✅ Pipeline 1 – Infrastructure Deployment (infrastructure_pipeline.yml)

- Automatically provisions all AWS infrastructure (VPC, ALBs, ECS, RDS, S3, etc.)
- Runs terraform init, plan, and apply
- Stores and retrieves Terraform state from the bootstrap S3 backend
- Uses GitHub OIDC to authenticate securely to AWS

# How It Works

Triggering the Workflow:
- Runs automatically to the `dev` environment on pushes to the main branch.
- Can also be triggered manually from the GitHub Actions UI using the “Run workflow” button.
- When run manually, it prompts for an environment selection (I have `dev` and `prod` environments but you can choose the 
names and how many you want, you only need to put the role arn in the secrets)using the workflow input field.

🧩 Pipeline 2 – Application Deployment (TODO) (app_deployment_pipeline.yml)

Will:

- Run tests on the app
- Build and push a Docker image to Amazon ECR
- Automatically update the ECS service with the new image version
- Intended to demonstrate a zero-downtime CI/CD release flow

## Key Components

- **Route 53 & CloudFront:** Global DNS and CDN for fast, secure content delivery.
- **ACM (AWS Certificate Manager):** Manages TLS/SSL certificates for HTTPS traffic.
- **VPC with Multi-AZ setup:** Ensures redundancy and high availability.
- **Public Subnets:** Host Internet Gateways and NAT Gateways for outbound access.
- **Private Subnets:** Contain compute resources and databases, fully isolated for security.
- **ECS / EC2 (Auto Scaling Groups):** Application containers and backend services scale automatically.
- **Application Load Balancers (ALB):** Distribute HTTP traffic to frontend and backend EC2s.
- **Amazon RDS:** Managed relational database for persistent data storage.
- **Amazon S3:** Used for CDN and ALB logs with lifecycle policies to Glacier Archive.
- **VPC Endpoints:** Enable private access to AWS services (S3, ECR, CloudWatch) without internet exposure.
- **AWS KMS:** Encrypts sensitive resources and CloudWatch Logs.

## Current Status / TODO

Some configurations are intentionally incomplete to keep the setup free-tier friendly.

- Add NAT Gateway configuration
- Clean up IAM policies in ecs_iam.tf
- Implement and test the App Deployment Pipeline (ECR + ECS update)
- Check everything is working as expected
- Make / attach to GitHub Actions a role with less permissions
- Make docker images upload pipeline
- Make pipeline that runs tests on PR raise
- Enable Route 53 & ACM resources once a custom domain is purchased 

## Notes for Reviewers

This project demonstrates:

- Infrastructure-as-Code (IaC) using Terraform
- Modular, reusable design
- GitHub Actions CI/CD pipelines with OIDC auth
- AWS best practices (private subnets, encryption, ALBs, HA design)
- Cost-conscious configuration (caches API calls with cdn)

The setup currently uses CloudFront’s default domain for HTTPS access to avoid paid domain registration.
All commented-out sections in the Terraform code can be re-enabled to support a custom domain later.

## License

You’re free to use, modify, or extend this setup for your own projects or learning.
If you deploy it with a paid domain, follow the comments in the Terraform files for configuration guidance.
