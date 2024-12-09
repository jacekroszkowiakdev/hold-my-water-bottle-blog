#!/bin/bash

# Update system
sudo yum update -y

# Configure AWS CLI with the credentials (ensure proper credentials are set)
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

# RDS credentials
RDS_DB_ENDPOINT=${aws_db_instance.multi_az_mariadb.endpoint}
WORDPRESS_DB_NAME=${var.db_name}
WORDPRESS_DB_USER=${var.db_user}
WORDPRESS_DB_PASSWORD=${var.db_password}

# Log credentials securely (no plain text credentials in logs)
echo "RDS_DB_ENDPOINT=${RDS_DB_ENDPOINT}" >> /home/ec2-user/db_envs.txt
echo "WORDPRESS_DB_NAME=${WORDPRESS_DB_NAME}" >> /home/ec2-user/db_envs.txt
echo "WORDPRESS_DB_USER=${WORDPRESS_DB_USER}" >> /home/ec2-user/db_envs.txt
echo "WORDPRESS_DB_PASSWORD=${WORDPRESS_DB_PASSWORD}" >> /home/ec2-user/db_envs.txt

# Update wp-config.php with the RDS database credentials
if [ -f /var/www/html/wordpress/wp-config.php ]; then
    sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'database_name_here'/'${WORDPRESS_DB_NAME}'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'username_here'/'${WORDPRESS_DB_USER}'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'password_here'/'${WORDPRESS_DB_PASSWORD}'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'localhost'/'${RDS_DB_ENDPOINT}'/g" /var/www/html/wordpress/wp-config.php
    echo "WordPress wp-config.php updated with RDS values." >> /home/ec2-user/db_OK.txt
else
    echo "wp-config.php not found!" >> /home/ec2-user/db_error.txt
fi

# Clean up
rm -f latest.tar.gz

# Restart Apache to apply changes
sudo systemctl restart httpd