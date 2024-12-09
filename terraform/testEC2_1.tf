data "aws_ami" "test_amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "test_ec2" {
  ami                    = data.aws_ami.test_amazon_linux2.id
  instance_type          = "t2.micro"
  key_name               = "vockey"
  subnet_id             = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.capstone_blog_sg.id]

  depends_on = [aws_db_instance.multi_az_mariadb]

  tags = {
    Name = "Test EC2 Instance 1"
  }

  # UserData script with the necessary environment variables set
  user_data = <<-EOF
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

    # RDS Credentials (AWS Database Instance Endpoint and Credentials)
    MARIADB_RDS_ENDPOINT="${aws_db_instance.multi_az_mariadb.endpoint}"
    MARIADB_DB_NAME="${var.db_name}"
    MARIADB_DB_USER="${var.db_user}"
    MARIADB_DB_PASSWORD="${var.db_password}"

    # Log RDS and DB credentials to a file (Ensure this is safe, as storing sensitive data in plaintext is not recommended)
    sudo touch /home/ec2-user/db.txt
    sudo chmod 777 /home/ec2-user/db.txt
    echo "DB name: $MARIADB_DB_NAME" >> /home/ec2-user/db.txt
    echo "DB user: $MARIADB_DB_USER" >> /home/ec2-user/db.txt
    echo "DB password: $MARIADB_DB_PASSWORD" >> /home/ec2-user/db.txt
    echo "RDS endpoint: $MARIADB_RDS_ENDPOINT" >> /home/ec2-user/db.txt

    # Update wp-config.php with the RDS database credentials
    sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'database_name_here'/'$MARIADB_DB_NAME'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'username_here'/'$MARIADB_DB_USER'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'password_here'/'$MARIADB_DB_PASSWORD'/g" /var/www/html/wordpress/wp-config.php
    sudo sed -i "s/'localhost'/'$MARIADB_RDS_ENDPOINT'/g" /var/www/html/wordpress/wp-config.php

    echo "WordPress wp-config.php updated with RDS values." >> db_OK.txt

    # Restart Apache to apply changes
    sudo systemctl restart httpd
  EOF
}
