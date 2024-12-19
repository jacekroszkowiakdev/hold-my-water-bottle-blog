#!/bin/bash

# Update system
sudo yum update -y

# Configure AWS CLI
aws configure set region "${region}"
aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"

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
sudo chmod -R 644 /var/www/html/wordpress

echo "${db_name}" >> /home/ec2-user/db.txt
echo "${db_user}" >> /home/ec2-user/db.txt
echo "${db_password}" >> /home/ec2-user/db.txt
echo "${db_endpoint}" >> /home/ec2-user/db.txt

echo "$domain_name" >> /home/ec2-user/domain.txt
echo "${domain_name}" >> /home/ec2-user/domain.txt

# Update wp-config.php
if [ -f /var/www/html/wordpress/wp-config-sample.php ]; then
  sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'database_name_here'/'${db_name}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'username_here'/'${db_user}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'password_here'/'${db_password}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s/'localhost'/'${db_endpoint}'/g" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s|^define('WP_SITEURL'.*|define('WP_SITEURL', 'http://$domain_name/wordpress');|" /var/www/html/wordpress/wp-config.php
  sudo sed -i "s|^define('WP_HOME'.*|define('WP_HOME', 'http://$domain_name');|" /var/www/html/wordpress/wp-config.php
  cat  /var/www/html/wordpress/wp-config.php >> /home/ec2-user/wp_summary.txt
  echo "WordPress configured successfully!" >> /home/ec2-user/wp_summary.txt
  else
  echo "wp-config.php not found!" >> /home/ec2-user/wp_error.txt
fi

# Restart Apache
sudo systemctl restart httpd

# Configure VirtualHost for the domain

VHOST_CONF="
<VirtualHost *:80>
    DocumentRoot /var/www/html/wordpress
    ServerName "hold-my-water-bottle.blog"
    AllowOverride All
    Require all granted
</VirtualHost>
"

# Append VirtualHost configuration to httpd.conf
echo "$VHOST_CONF" | sudo tee -a /etc/httpd/conf/httpd.conf

# Restart Apache
sudo systemctl restart httpd

# Create stress_test script
sudo touch /home/ec2-user/stress_test.sh
sudo chmod 700 stress_test.sh
echo '#!/bin/bash' >> /home/ec2-user/stress_test.sh
echo "Installing stress test..." >> /home/ec2-user/stress_test.sh
echo sudo yum install -y stress >> /home/ec2-user/stress_test.sh
echo "Starting stress test..." >> /home/ec2-user/stress_test.sh
echo stress --cpu 8 --timeout 300 >> /home/ec2-user/stress_test.sh
echo "Stress test completed." >> /home/ec2-user/stress_test.sh