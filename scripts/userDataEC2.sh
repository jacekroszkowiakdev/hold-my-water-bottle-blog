#!/bin/bash
# Update and install Apache, PHP, and WordPress

# Update packages and install required software
sudo yum update -y
sudo yum install -y httpd mariadb-server php php-mysqlnd php-fpm php-xml php-cli php-json php-common wget unzip

# Enable and start Apache and MariaDB
sudo systemctl enable httpd mariadb
sudo systemctl start httpd mariadb

# Configure MariaDB
sudo mysql -e "CREATE DATABASE wordpress;"
sudo mysql -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install WordPress
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
sudo chown -R apache:apache /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress

# Configure WordPress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo sed -i "s/database_name_here/wordpress/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/wordpressuser/" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/password/" /var/www/html/wordpress/wp-config.php

# Open HTTP traffic on the firewall
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload

# Restart Apache to apply changes
sudo systemctl restart httpd
