# key pair

resource "aws_key_pair" "my_key" {
    key_name = "keyy-ec2"
    public_key = file("keyy-ec2.pub")
  
}

# VPC
resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "my_security_group" {
    name="jenkins-sg"
    description = "allow mysql traffic"
    vpc_id = aws_default_vpc.default.id

    # inbound rule
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh open"
    }

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh open"

    }
    ingress{
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "flask app"
    }
    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Jenkins UI"
    }
    # ✅ MySQL access only from same SG (EC2s in this SG)
    ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = [aws_default_vpc.default.cidr_block]
    description     = "MySQL access from ec2 in vpc"
    }
  
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
        description = "all access"
    } 

    tags ={
        name="automate-sg"
    }
}
# Fetch default VPC subnets
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# Agent master
resource "aws_instance" "jenkins_master" {
    key_name = aws_key_pair.my_key.key_name
    # security_groups = [aws_security_group.my_security_group.name] used in 2013
    vpc_security_group_ids = [aws_security_group.my_security_group.id] # better
    instance_type = var.ec2_instance_type
    ami = var.ec2_ami_id
    user_data = file("jenkins-install.sh")
    root_block_device {
      volume_size = 20
      volume_type = "gp3"
    }
    tags = {
        Name = "deepak-master"
    }
}
resource "aws_instance" "jenkins_agent" {
    key_name = aws_key_pair.my_key.key_name
    # security_groups = [aws_security_group.my_security_group.name] used in 2013
    vpc_security_group_ids = [aws_security_group.my_security_group.id] # better
    instance_type = var.ec2_instance_type
    ami = var.ec2_ami_id
    user_data = file("docker_mysql_install.sh")
    root_block_device {
      volume_size = 10
      volume_type = "gp3"
    }
    tags = {
        Name = "deepak-agent"
    }
}