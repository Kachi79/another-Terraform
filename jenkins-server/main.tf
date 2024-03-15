module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-cicd-eks-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets

  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins-subnet"
  }
}

##sg
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-server"
  description = "Security group jenkins for jenkins server"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      description = "HTTP"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      description = "SSH"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "jenkins-sg"
  }
}

##EC2-INSTANCE
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type               = var.instance_type
  key_name                    = "jenkinskey"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  ami                         = data.aws_ami.example.id
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.azs.names[0]
  user_data                   = file("jenkins-install.sh")


  tags = {
    Name        = "jenkins_instance"
    Terraform   = "true"
    Environment = "dev"
  }
}