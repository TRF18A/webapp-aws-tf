# aws access key. must be provided.
variable "access_key" {}

# aws secret key. must be provided. 
variable "secret_key" {}

# name of keypair. must be provided.
# if set to "KEYPAIR1", you must have 
# "KEYPAIR1.pem" file locally for ssh into 
# EC2 instances
variable "keypair" {}

# ami used for creating the EC2 web instances 
# note that these are region specific
variable "ami" {}
# instance type, e.g. "t2-micro"
variable "instance_type" {}

###########################
# these variables set the region,
# the availability zones, and
# the cidr blocks to be used for 
# the vpc and the subnets within
###########################
variable "region" {}
variable "az_1" {}
variable "az_2" {}
variable "vpc_cidr_block" {}
variable "subnet_web1_cidr_block" {}
variable "subnet_web2_cidr_block" {}
variable "subnet_db1_cidr_block" {}
variable "subnet_db2_cidr_block" {}

###########################
# the db username and password
# used when creating the aws rds instances
###########################
variable "db_username" {}
variable "db_password" {}
