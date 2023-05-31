# AWS Two Tier Web App
 AWS Two tier web app with RDS Db
This is mostly taken from various tutorials showing how to use Terraform.

- Probably should be broken down to include variables.tf file for best practises.

- Creates resources in the AWS new Melbourne region (ap-southeast-4) so care should be taken to adjust accordingly for your region.

** Uses an AMI that I created that includes Apache2, PHP and MySQL client. These are for hosting the PHP db web app and for connection to the RDS DB. This AMI is available publically from the ap-southeast-4 region or you can create an instance with these then use the AWS console to clone an image into your AMI repo in which case you will need to create the PHP db application. The tutorial: Install a web server on your EC2 instance at https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Tutorials.WebServerDB.CreateWebServer.html will take you through how to create a simple PHP web application to test the DB on the back-end.
