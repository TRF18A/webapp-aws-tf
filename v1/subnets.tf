resource "aws_subnet" "web_subnet_1" {
  vpc_id                  = "${aws_vpc.vpc_webapps.id}"
  cidr_block              = "${var.subnet_web1_cidr_block}"
  availability_zone       = "${var.az_1}" 	

  tags {
    Name = "web_subnet_1"
  }
}
resource "aws_subnet" "web_subnet_2" {
  vpc_id                  = "${aws_vpc.vpc_webapps.id}"
  cidr_block              = "${var.subnet_web2_cidr_block}"
  availability_zone       = "${var.az_2}"

  tags {
    Name = "web_subnet_2"
  }
}
resource "aws_subnet" "db_subnet_1" {
  vpc_id                  = "${aws_vpc.vpc_webapps.id}"
  cidr_block              = "${var.subnet_db1_cidr_block}"
  availability_zone       = "${var.az_1}"
  
  tags {
    Name = "db_subnet_1"
  }
}
resource "aws_subnet" "db_subnet_2" {
  vpc_id                  = "${aws_vpc.vpc_webapps.id}"
  cidr_block              = "${var.subnet_db2_cidr_block}"
  availability_zone       = "${var.az_2}"
  
  tags {
    Name = "db_subnet_1"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = ["${aws_subnet.db_subnet_1.id}", "${aws_subnet.db_subnet_2.id}"]

  tags {
    Name = "DB subnet group"
  }
}

resource "aws_route_table_association" "ra_web1" {
  subnet_id      = "${aws_subnet.web_subnet_1.id}"
  route_table_id = "${aws_route_table.vpc_route_table.id}"
}

resource "aws_route_table_association" "ra_web2" {
  subnet_id      = "${aws_subnet.web_subnet_2.id}"
  route_table_id = "${aws_route_table.vpc_route_table.id}"
}

resource "aws_route_table_association" "ra_db1" {
  subnet_id      = "${aws_subnet.db_subnet_1.id}"
  route_table_id = "${aws_route_table.vpc_route_table.id}"
}
resource "aws_route_table_association" "ra_db2" {
  subnet_id      = "${aws_subnet.db_subnet_2.id}"
  route_table_id = "${aws_route_table.vpc_route_table.id}"
}
