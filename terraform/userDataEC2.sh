#!/bin/bash

# Update system
sudo yum update -y

# Configure AWS CLI with the credentials
aws configure set region "us-west-2"

# Verify the configuration
aws sts get-caller-identity > /var/log/aws_caller_identity.log 2>&1

# Install and configure Apache
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Install PHP and related packages
sudo yum install -y wget unzip php-cli php-fpm php-mysqlnd php-json php-opcache php-xml php-gd php-mbstring

# Enable and install PHP 7.4
sudo amazon-linux-extras enable php7.4
sudo yum clean all
sudo yum install -y php php-cli php-fpm php-mysqlnd php-json php-opcache php-xml php-gd php-mbstring
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# Install WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R apache:apache /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# DB credentials
RDS_ENDPOINT="${rds_endpoint}"
DB_NAME="${rds_db_name}"
DB_USER="${rds_username}"
DB_PASSWORD="${rds_password}"

# Log RDS and DB credentials to a file
echo "RDS endpoint: $RDS_ENDPOINT" > /home/ec2-user/db.txt
echo "DB name: $DB_NAME" >> /home/ec2-user/db.txt
echo "DB user: $DB_USER" >> /home/ec2-user/db.txt
echo "DB password: $DB_PASSWORD" >> /home/ec2-user/db.txt

# Update wp-config.php with the RDS database credentials
sudo cp ./wp-config-sample.php ./wp-config.php
sudo sed -i "s/'database_name_here'/'$DB_NAME'/g" wp-config.php
sudo sed -i "s/'username_here'/'$DB_USER'/g" wp-config.php
sudo sed -i "s/'password_here'/'$$DB_PASSWORD'/g" wp-config.php
sudo sed -i "s/'localhost'/'$RDS_ENDPOINT'/g" wp-config.php

# Restart Apache to apply changes
sudo systemctl restart httpd
