# webapp-aws-tf
Terraform template to create infra for Web Application hosting in the AWS Cloud

## Architecture
1. This Terraform script creates AWS infra for hosting a three tier web application (e.g. a web API). The client running in the web browser (e.g. a single page application), the web/app server containing the business logic and the backing store in the form of a relational database make up the tiers. An Elastic Load Balancer is used to distribute requests to web/app servers residing in different availability zones. The web/app servers connect to a relational database - here RDS implementation of MySQL as a service is used. Please see diagram below.
2. No assumptions are made about existing AWS components within the environment; a fresh vpc is created with all the required components.
3. A **High Availability (HA)** infrastructure is created, able to withstand loss of a web/app server and/or database server. Alternately it is able to withstand the loss of an Availability Zone (AZ).
4. A dummy php web application is used for demonstration purposes; the focus is on use of Terraform. 
![Diagram](https://trf18a.github.io/TerraformArch.jpg "Diagram")

### Components
1. Load Balancer - Classic ELB is used to send requests to web/sapp servers in cross-AZ mode in Round Robin fashion.
2. EC2 - Used to host the web/app server. One in each AZ.
3. MySQL RDS - Database as a service, deployed in Multi-AZ (HA) mode. 
4. Security Groups - Instance level stateful firewall used to restrict access by protocol, origin/destination and port. In this setup, the web security group allows connections on port 80 only from the ELB security group. The RDS security group allows MySQL TCP connections only from the web security group.
5. Subnets - Subnets are defined within the VPC to partition the network and to support network level access controls.  

## How to apply
1. Clone https://github.com/TRF18A/webapp-aws-tf.git
2. Edit the variables in terraform.tfvars as needed. The access key and security kay, as well as the keypair name must be provided. Other variables have default values that may be overriden. Database id and password may be changed to appropriate values.
3. Install terraform and apply.
4. Note the database_hostname and elb_dns_name output variables 
5. During EC2 instance creation php will be installed some sample php pages will be copied in to test connectivity to the database.
6. Point browser to the url of the load balancer (i.e. elb_dns_name). A pages with a link to the "sayHello" page should appear. Pressing refresh should change the displayed server ip address.  
7. ssh into the both the EC2 web instances and edit the sayHello.php file. Change the database hostname to the value output as database_hostname. Also change the database id and password in line with what was provided in the Terraform script. 
8. Clicking on the "sayHello" link should result in a hello message displayed, as well as the database connectivity status displayed.

## Notes
1. The php sample pages are for demo only. In production a more appropriate stack may be deployed, e.g using Spring Boot.
2. The service discovery steps (i.e. application obtaining the RDS endpoint) should be automated, perhaps using DNS or Hashicorp Consul etc.
3. Autoscaling group may be used to scale and automatically maintain the target number of running instances.
4. The scripts define segregated subnets but do not define any subnet NACLs. Subnet level NACLs may be used to further tighten security and act as a safeguard against misconfigured Security Groups.
5. The script can be changed to make port numbers configurable and to permit HTTPS traffic.  
