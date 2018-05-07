# webapp-aws-tf
Terraform template to create infra for Web Application hosting in the AWS Cloud

## Architecture
1. This Terraform script creates AWS infra for hosting a three tier web application (e.g. a web API). The client running in the web browser (e.g. a single page application), the web/app server containing the business logic and the backing store in the form of a relational database make up the tiers. An Elastic Load Balancer is used to distribute requests to web/app servers residing in different availability zones. The web/app servers connect to a relational database - here RDS implementation of MySQL as a service is used.
2. No assumptions are made about existing AWS components within the environment; a fresh vpc is created with all the required components.
3. A **High Availability (HA)** infrastructure is created, able to withstand loss of a web/app server and/or database server. Alternately it is able to withstand the loss of an Availability Zone (AZ).
4. A dummy php web application is used for demonstration purposes; the focus is on use of Terraform. 

## Components




## How to apply

## Notes

