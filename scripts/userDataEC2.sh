#!/bin/bash

# Update system
sudo yum update -y

# Set AWS credentials using values passed from Terraform
AWS_REGION="${TF_VAR_AWS_REGION}"
AWS_ACCESS_KEY_ID="${TF_VAR_AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY="${TF_VAR_AWS_SECRET_ACCESS_KEY}"
AWS_SESSION_TOKEN="${TF_VAR_AWS_SESSION_TOKEN}"

# Log the variables to a log file for debugging
LOG_FILE="/var/log/aws_credentials.log"

{
  echo "AWS_REGION=${AWS_REGION}"
  echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
  echo "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
  echo "AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}"
} > "$LOG_FILE"

# Configure AWS CLI with the credentials
aws configure set region "$AWS_REGION"
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
aws configure set aws_session_token "$AWS_SESSION_TOKEN"

# Verify the configuration
aws sts get-caller-identity > /var/log/aws_caller_identity.log 2>&1

# Install and configure Apache
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Install PHP and related packages
sudo yum install -y mariadb-server wget unzip php-cli php-fpm php-mysqlnd php-json php-opcache php-xml php-gd php-mbstring

# Enable and install PHP 7.4
sudo amazon-linux-extras enable php7.4
sudo yum clean all
sudo yum install -y php php-cli php-fpm php-mysqlnd php-json php-opcache php-xml php-gd php-mbstring

# Install WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R apache:apache /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Get the RDS endpoint
RDS_ENDPOINT=""
while [ -z "$RDS_ENDPOINT" ]; do
  echo "Waiting for RDS endpoint..."
  RDS_ENDPOINT=$(aws rds describe-db-instances --query "DBInstances[?DBInstanceIdentifier=='capstone-mariadb-instance'].Endpoint.Address" --output text)
  sleep 10  # Wait for 10 seconds before checking again
done

echo "RDS endpoint: $RDS_ENDPOINT"

DB_NAME="${TF_VAR_DB_NAME}"
DB_USER="${TF_VAR_DB_USER}"
DB_PASSWORD="${TF_VAR_DB_MASTER_PASSWORD}"

# Update wp-config.php with the RDS database credentials
sudo sed -i "s/define('DB_NAME', 'wordpress');/define('DB_NAME', '$DB_NAME');/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/define('DB_USER', 'wordpressuser');/define('DB_USER', '$DB_USER');/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/define('DB_PASSWORD', 'password');/define('DB_PASSWORD', '$DB_PASSWORD');/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/define('DB_HOST', 'localhost');/define('DB_HOST', '$RDS_ENDPOINT');/g" /var/www/html/wordpress/wp-config.php

# Open HTTP traffic on the firewall
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload

# Restart Apache to apply changes
sudo systemctl restart httpd
