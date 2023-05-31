# AWS Two Tier Web App
 AWS Two tier web app with RDS Db
This is mostly taken from various tutorials showing how to use Terraform.

- Probably should be broken down to include variables.tf file for best practises.

- Creates resources in the AWS new Melbourne region (ap-southeast-4) so care should be taken to adjust accordingly for your region.

** Uses an AMI that I created that includes Apache2, PHP and MySQL client. These are for hosting the PHP db web app and for connection to the RDS DB. You can create an instance with these then use the AWS console to clone an image into your AMI repo.
