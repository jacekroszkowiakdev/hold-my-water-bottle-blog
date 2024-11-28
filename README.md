# WordPress blog on AWS with Terraform and Scrum

**Project Overview**

This project demonstrates the deployment of a scalable and fault-tolerant WordPress website on Amazon Web Services (AWS) using Terraform for infrastructure automation, Scrum methodology for project management, and Git/GitHub for collaboration. The architecture leverages Auto Scaling groups for horizontal scalability and redundancy across multiple Availability Zones for fault tolerance. Security best practices are integrated with IAM roles and Security Groups.

**Project Objectives:**

-   Design a scalable and fault-tolerant architecture for WordPress on AWS
-   Automate infrastructure deployment with Terraform
-   Collaborate effectively on infrastructure and code using Git and GitHub
-   Manage project delivery iteratively with Scrum methodology
-   Implement security best practices in AWS with IAM and Security Groups

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
