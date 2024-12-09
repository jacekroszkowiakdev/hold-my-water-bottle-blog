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
RDS_MARIADB_ENDPOINT=${aws_db_instance.multi_az_mariadb.endpoint}
DB_MARIADB_NAME=${var.db_name}
DB_MARIADB_USER=${var.db_user}
DB_MARIADB_PASSWORD=${var.db_password}

# Log RDS and DB credentials to a file (secure handling recommended)
sudo touch /home/ec2-user/db.txt
sudo chmod 600 /home/ec2-user/db.txt
echo "MARIADB name: $DB_MARIADB_NAME" >> /home/ec2-user/db.txt
echo "MARIADB user: $DB_MARIADB_USER" >> /home/ec2-user/db.txt
echo "MARIADB password: $DB_MARIADB_PASSWORD" >> /home/ec2-user/db.txt
echo "MARIADB endpoint: $RDS_MARIADB_ENDPOINT" >> /home/ec2-user/db.txt

# Update wp-config.php with the RDS database credentials
if [ -f /var/www/html/wordpress/wp-config.php ]; then
    sudo sed -i "s/'database_name_here'/'$DB_MARIADB_NAME'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'username_here'/'$DB_MARIADB_USER'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'password_here'/'$DB_MARIADB_PASSWORD'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'localhost'/'$RDS_MARIADB_ENDPOINT'/g" /var/www/html/wordpress/wp-config.php
    echo "WordPress wp-config.php updated with RDS values." >> db_OK.txt
else
    echo "wp-config.php not found!" >> db_error.txt
fi

# Clean up
rm -f latest.tar.gz

# Restart Apache to apply changes
sudo systemctl restart httpd
