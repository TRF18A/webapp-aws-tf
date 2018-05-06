# sg stands for security group here ...


#allow mysql tcp connections only from the web security group
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  description = "VPC security group for RDS"
  vpc_id="${aws_vpc.vpc_webapps.id}"
  
  # TCP access
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${aws_security_group.web_sg.id}"]
  }

  # TCP access to anywhere
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_sg" {
  name = "elb_sg"
  description = "elb security group"
  vpc_id="${aws_vpc.vpc_webapps.id}"

  # TCP access
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # TCP access to anywhere
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#allow http connections only from the elb security group
resource "aws_security_group" "web_sg" {
  name = "web_sg"
  description = "web security group"
  vpc_id="${aws_vpc.vpc_webapps.id}"

  # TCP access
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.elb_sg.id}"]
  }

  # TCP access
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP access to anywhere
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
