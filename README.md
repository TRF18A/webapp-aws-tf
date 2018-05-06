# webapp-aws-tf
Terraform template for AWS hosted API infrastructure

## Architecture
1. This Terraform script creates AWS infra for hosting a three tier web application. The client running in the browser, the web/app server containing the business logic and the backing store in the form of a relational database make up the layers.
2. No assumptions are made about existing AWS components within the environment; a fresh vpc is created with all the required components.
3. A High Availability (HA) infrastructure is created, able to withstand loss of a web/app server and/or database server. Alternately it is able to withstand the loss of an Availability Zone (AZ).

## Components




## How to apply

## Notes

