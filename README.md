# AWS Two Tier Web App
 AWS Two tier web app with RDS Db. This is mostly taken from various tutorials showing how to use Terraform. 

- Creates the VPC containing the infrastructure.
- Creates an Internet Gateway (IGW) and connects it to an Application Load Balancer (ALB).
- Creates the route tables.
- Creates the frontend public subnets and security groups (http/SSH) across two avaialbility zones and places 2 x t3.micro Ubuntu instances in the zones, as Web Servers.
- Creates an ALB target group consisting of the two Web servers with an HTTP forwarder and health check.
- Creates an RDS Db instance with a small storage using MySQL in one Availability Zone.
- Web servers connect to the RDS Db instance via backend private subnets with security groups (10.0.0.0/16>MySQL) for secure connectivity to the RDS Db.

Notes:
- Probably should be broken down to include a variables.tf file for best practises. Variables file could be used to change AZ's, db storage settings, etc.

- Creates resources in the new AWS Melbourne region (ap-southeast-4) so care should be taken to adjust accordingly for your region.

** Uses an AMI that I created that includes Apache2, PHP and MySQL client. These apps are required for hosting the PHP Db web app and for connection to the RDS DB. This AMI is available publically from the ap-southeast-4 region or you can create an instance with these then use the AWS console to clone an image into your AMI repo in which case you will need to create the PHP db application. The tutorial: Install a web server on your EC2 instance at https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateWebServer.html will take you through how to create a simple PHP web application to test the DB on the back-end.
