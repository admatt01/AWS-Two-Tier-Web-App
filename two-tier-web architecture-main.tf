# Brainboard auto-generated file.

resource "aws_vpc" "web-app-vpc" {
  instance_tenancy = "default"
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Web-infra"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.web-app-vpc.id

  tags = {
    Name = "ig-project"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.web-app-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-4a"

  tags = {
    Name = "1public"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.web-app-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-4b"

  tags = {
    Name = "2public"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.web-app-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-southeast-4a"

  tags = {
    Name = "1private"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.web-app-vpc.id
  map_public_ip_on_launch = false
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-southeast-4b"

  tags = {
    Name = "2private"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.web-app-vpc.id

  route {
    gateway_id = aws_internet_gateway.ig.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "routetable"
  }
}

resource "aws_route_table_association" "route1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "route2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "publicsg" {
  vpc_id      = aws_vpc.web-app-vpc.id
  name        = "publicsg"
  description = "Allow traffic"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "privatesg" {
  vpc_id      = aws_vpc.web-app-vpc.id
  name        = "privatesg"
  description = "Allow traffic"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "albsg" {
  vpc_id      = aws_vpc.web-app-vpc.id
  name        = "albsg"
  description = "ALB Security Group"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_lb" "alb" {
  name               = "alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [
    aws_security_group.albsg.id,
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id,
  ]
}

resource "aws_lb_target_group" "albtg" {
  vpc_id   = aws_vpc.web-app-vpc.id
  protocol = "HTTP"
  port     = 80
  name     = "albtg"

  depends_on = [
    aws_vpc.web-app-vpc,
  ]
}

resource "aws_lb_target_group_attachment" "tgattach1" {
  target_id        = aws_instance.Webserver1.id
  target_group_arn = aws_lb_target_group.albtg.arn
  port             = 80

  depends_on = [
    aws_instance.Webserver1,
  ]
}

resource "aws_lb_target_group_attachment" "tg_attach2" {
  target_id        = aws_instance.Webserver2.id
  target_group_arn = aws_lb_target_group.albtg.arn
  port             = 80

  depends_on = [
    aws_instance.Webserver2,
  ]
}

resource "aws_lb_listener" "lblisten" {
  protocol          = "HTTP"
  port              = 80
  load_balancer_arn = aws_lb.alb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtg.arn
  }
}

resource "aws_instance" "Webserver1" {
  subnet_id                   = aws_subnet.public1.id
  instance_type               = "t3.micro"
  availability_zone           = "ap-southeast-4a"
  associate_public_ip_address = true
  ami                         = "ami-0f809b5fd09dbf10a"
  key_name                    = "web-servers"

  tags = {
    Name = "Webserver-1"
  }

  vpc_security_group_ids = [
    aws_security_group.publicsg.id,
  ]
}

resource "aws_instance" "Webserver2" {
  subnet_id                   = aws_subnet.public2.id
  instance_type               = "t3.micro"
  availability_zone           = "ap-southeast-4b"
  associate_public_ip_address = true
  ami                         = "ami-0f809b5fd09dbf10a"
  key_name                    = "web-servers"

  tags = {
    Name = "Webserver-2"
  }

  vpc_security_group_ids = [
    aws_security_group.publicsg.id,
  ]
}

resource "aws_db_subnet_group" "dbsubnet" {
  name = "dbsubnet"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id,
  ]
}

resource "aws_db_instance" "dbinstance" {
  username             = "admin"
  skip_final_snapshot  = true
  password             = "password"
  instance_class       = "db.t3.micro"
  identifier           = "dbinstance"
  availability_zone    = "ap-southeast-4a"
  engine_version       = "5.7"
  engine               = "mysql"
  db_subnet_group_name = aws_db_subnet_group.dbsubnet.id
  db_name              = "db"
  allocated_storage    = 5

  vpc_security_group_ids = [
    aws_security_group.privatesg.id,
  ]
}

