#!/bin/bash

# Update system
sudo yum update -y

# Configure AWS CLI
aws configure set region "us-west-2"

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

echo "${db_name}" >> /home/ec2-user/db.txt
echo "${db_user}" >> /home/ec2-user/db.txt
echo "${db_password}" >> /home/ec2-user/db.txt
echo "${db_endpoint}" >> /home/ec2-user/db.txt

# Update wp-config.php
if [ -f /var/www/html/wordpress/wp-config-sample.php ]; then
  sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'database_name_here'/'${db_name}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'username_here'/'${db_user}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'password_here'/'${db_password}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'localhost'/'${db_endpoint}'/g" /var/www/html/wordpress/wp-config.php
  echo "WordPress wp-config.php updated successfully!" >> /home/ec2-user/db_OK.txt
else
  echo "wp-config.php not found!" >> /home/ec2-user/db_error.txt
fi

# Restart Apache
sudo systemctl restart httpd