# WordPress blog on AWS with Terraform

## Project Overview

The objective of this project is to automate the deployment of a scalable, fault-tolerant WordPress website on AWS using Terraform. We will utilize Git for version control and GitHub for collaborative development, adhering to Agile Scrum principles for efficient project management.

This project will implement a fault-tolerant and scalable WordPress architecture on AWS. We will use Terraform to provision EC2 instances, configure an ALB for load balancing, create an ASG for automatic scaling, and deploy an RDS database. Python scripts will be used to automate additional configuration and deployment tasks.

The intended audience are fellow students and instructors of the Neuefische AWS Course.

**Project Requrements**

Functional Requirements:

-   The website must scale automatically based on traffic.
-   The WordPress site must remain available even if one availability zone fails.

Non-Functional Requirements:

-   Availability: 99.9%
-   Latency: Response time under 200ms for 95% of requests.
-   Security: Use of IAM roles, Security Groups, and HTTPS.

**Project Objectives:**

-   Design a scalable and fault-tolerant architecture for WordPress on AWS
-   Automate infrastructure deployment with Terraform
-   Collaborate effectively on infrastructure and code using Git and GitHub
-   Manage project delivery iteratively with Scrum methodology
-   Implement security best practices in AWS with IAM and Security Groups

**Architecture Design**

The architecture comprises a Virtual Private Cloud (VPC) with public and private subnets. An Internet Gateway (IGW) is attached to the VPC to provide internet connectivity. Separate route tables are configured for public and private subnets to control traffic flow. A Security Group is implemented to restrict inbound and outbound traffic to essential ports (HTTP and SSH).

The compute layer consists of EC2 instances, pre-configured with Apache, PHP, and WordPress. These instances are launched from an Auto Scaling Group (ASG) to ensure automatic scaling based on load. The ASG is configured with a minimum of 1, desired capacity of 2, and a maximum of 4 instances. A User Data script is used to automate the configuration of WordPress on each instance launch.

An Application Load Balancer (ALB) is deployed to distribute incoming traffic across multiple EC2 instances. The ALB is configured with a Target Group and Listener to route traffic to the appropriate instances.

For persistent data storage, an Amazon Relational Database Service (RDS) instance in Multi-AZ deployment is used. This ensures high availability and durability of the database.

![Architecture Diagram](./documents/capstone_cloud_diagramterraform workspace list.png)

**Infrastructure Components**

-   Virtual Private Cloud (VPC):

    -   Two Public Subnets
    -   Two Private Subnets
    -   Internet Gateway (IGW)
    -   Separate Route Tables for Public and Private Subnets
    -   Security Group: Allows HTTP and SSH Traffic

-   Compute Resources:

    -   EC2 Instances:

        -   Pre-configured with Apache, PHP, and WordPress
        -   Connected to RDS Database for Data Storage
        -   Utilize User Data for Automated Configuration

    -   Auto Scaling Group (ASG):

        -   Minimum Capacity: 1 Instance
        -   Desired Capacity: 2 Instances
        -   Maximum Capacity: 4 Instances

    -   Load Balancing:

        -   Application Load Balancer (ALB)
        -   Target Group
        -   Listener Configuration

**Technologies:**

-   Infrastructure as Code (IaC): Terraform
-   Cloud Platform: AWS
-   Content Management System (CMS): WordPress
-   Version Control System (VCS): Git
-   Collaboration Platform: GitHub
-   Project Management Methodology: Scrum

**Project Structure:**

-   `terraform`: Contains Terraform configuration files defining the AWS infrastructure.
-   `documents`: Houses project documentation, including architecture diagrams, security considerations, etc.
-   `scripts`: Provides scripts for deployment automation, testing, or other project-specific tasks (optional).
-   `.gitignore`: Specifies files or directories to be excluded from Git version control.

### Getting Started:

1. **Prerequisites:**

    - A working AWS account
    - Terraform installed locally ([https://www.terraform.io/downloads](https://www.google.com/url?sa=E&source=gmail&q=https://www.terraform.io/downloads))
    - Git client installed ([https://git-scm.com/](https://www.google.com/url?sa=E&source=gmail&q=https://git-scm.com/))
    - Familiarity with Git and GitHub concepts

2. **Clone the Repository:**

    ```bash
    git clone https://github.com/jacekroszkowiakdev/hold-my-water-bottle-blog.git
    ```

3. **Configure AWS Credentials:**

    Set up your AWS access key and secret key in environment variables (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY) or configure a local AWS profile.

4. **Review Terraform Configuration:**

    Review the .tf files in the terraform directory to understand the infrastructure components being defined.

5. **Deploy Infrastructure:**

```bash
cd terraform
terraform init
terraform apply
```

---

### Additional Resources:

-   [Terraform Documentation](https://www.terraform.io/docs/)
-   [AWS Documentation](https://docs.aws.amazon.com/)
-   [WordPress Documentation](https://codex.wordpress.org/)

### Stay in touch

Author: Jacek Roszkowiak

-   [Github](https://github.com/jacekroszkowiakdev)
-   [LinkedIn](https://www.linkedin.com/in/jacekroszkowiak/)
-   [Instagram](https://www.instagram.com/jroszko/)
