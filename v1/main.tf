provider "aws" {
  access_key = "${var.access_key}" 
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "web1" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "KEYPAIR1"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  subnet_id              = "${aws_subnet.web_subnet_1.id}"
  
  user_data = <<-EOF
    #!/bin/bash
    yum install httpd php php-mysql -y
    yum update -y
    chkconfig httpd on
    service httpd start
    echo "<?php phpinfo();?>" > /var/www/html/index.php
    cd /var/www/html
    wget https://s3.eu-west-2.amazonaws.com/acloudguru-example/connect.php
    EOF

  tags {
    Name = "web1"
  }
}

resource "aws_instance" "web2" {
  ami           = "ami-64260718"
  instance_type = "t2.micro"
  key_name = "KEYPAIR1"
  vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
  subnet_id              = "${aws_subnet.web_subnet_2.id}"
  
  user_data = <<-EOF
    #!/bin/bash
    yum install httpd php php-mysql -y
    yum update -y
    chkconfig httpd on
    service httpd start
    echo "<?php phpinfo();?>" > /var/www/html/index.php
    cd /var/www/html
    wget https://s3.eu-west-2.amazonaws.com/acloudguru-example/connect.php
    EOF

  tags {
    Name = "web2"
  }
}


resource "aws_vpc" "vpc_webapps" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  
  tags {
    Name = "webapps"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc_webapps.id}"

  tags {
    Name = "webapps_igw"
  }
}


resource "aws_elb" "classic_elb_1" {
  name               = "classic-elb-1"
  # availability_zones = ["${var.az_1}","${var.az_2}"]
 
 subnets = ["${aws_subnet.web_subnet_1.id}","${aws_subnet.web_subnet_2.id}"]
 security_groups = ["${aws_security_group.elb_sg.id}"]  
  
  #access_logs {
  #  bucket        = "foo"
  #  bucket_prefix = "bar"
  #  interval      = 60
  #}

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.web1.id}", "${aws_instance.web2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "webapps elb"
  }
}

resource "aws_route_table" "vpc_route_table" {
  vpc_id = "${aws_vpc.vpc_webapps.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "aws_route_table"
  }
}

resource "aws_db_instance" "rds_mysql" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "db_subnet_group"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  multi_az             = "true"
}

data "aws_db_instance" "rds_data" {
  db_instance_identifier = "${aws_db_instance.rds_mysql.id}"
}

output "database_hostname" {
  value = "${data.aws_db_instance.rds_data.endpoint}"
}

output "elb_dns_name" {
  value = "${aws_elb.classic_elb_1.dns_name}"
}
