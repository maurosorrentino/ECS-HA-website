![Architecture Diagram](architecture.jpg)

# ECS High Availability Failover Website

This project demonstrates a high-availability website architecture using AWS ECS, CloudFront, and related services. The goal is to provide a resilient, scalable web application.

> **Note:**  
> The provided code and configuration are mostly complete, but not everything is fully functional yet and some part of the 
code needs cleanup.  
> The final step—registering a custom domain is missing and Route 53, Certificate Manager code is commented out, as it requires a paid domain 
registration.  
> For now, the setup uses the default CloudFront domain, which is already secure.

## TODO

- Fix ASG, ECS service, SG errors.
- NAT gateway.
- Cleanup ecs_iam.tf file.

## License

You can use the code if you like to deploy the infrastructure, just follow the instructions in the comments if you want to
pay and own a custom domain.
