#!/bin/bash
# Update and install Apache, PHP, and WordPress

sudo yum update -y
sudo yum install -y httpd

# Install PHP and required extensions
sudo yum install -y php php-mysqlnd php-fpm php-xml php-cli php-json php-common

sudo yum install -y wget unzip

# Download and configure WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz

sudo mv wordpress /var/www/html/
sudo chown -R apache:apache /var/www/html/wordpress

# Start Apache web server
sudo systemctl enable httpd
sudo systemctl start httpd

# Open HTTP port on firewall
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
