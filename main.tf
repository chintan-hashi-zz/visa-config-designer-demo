//--------------------------------------------------------------------
// Variables

provider "aws" {
  region  = "us-west-1"
}

//--------------------------------------------------------------------
// Modules

module "ec2_instance" {
  source  = "app.terraform.io/hc-se-demo-chintan/ec2-instance/aws"
  version = "2.20.0"

  ami = "ami-059fd73d4594fa21c"
  instance_type = "t2.micro"
  key_name = "cgosalia-aws-key"
  name = "cgosalia-vault-test-1"
  subnet_id = "subnet-024d03616522c6a61"
  vpc_security_group_ids = concat(module.security_group.this_security_group_id, module.security_group_2.this_security_group_id)
}

module "elb" {
  source  = "app.terraform.io/hc-se-demo-chintan/elb/aws"
  version = "2.4.3"

  instances = tolist(module.ec2_instance.id)
  internal = "false"
  name = "cgosalia-vault-elb"
}

module "security_group" {
  source  = "app.terraform.io/hc-se-demo-chintan/security-group/aws"
  version = "3.28.0"

  cidr_block = ["0.0.0.0/0"]
  description = "cgosalia vault visa test security group"
  from_port = 80
  name = "cgosalia-vault-sg-test"
  protocol = "TCP"
  rule_description = "cgosalia vault visa test security group"
  to_port = 8201
  vpc_id = "vpc-00e43c5433b4eb92c"
}

module "security_group_2" {
  source  = "app.terraform.io/hc-se-demo-chintan/security-group/aws"
  version = "3.28.0"

  cidr_block = ["0.0.0.0/0"]
  description = "visa day 2 operation security group"
  from_port = 10
  name = "cgosalia-visa-day2-sg"
  protocol = "UDP"
  rule_description = "visa day 2 operation security group"
  to_port = 100
  vpc_id = "vpc-00e43c5433b4eb92c"
}

module "ebs_volume" {
  source  = "app.terraform.io/hc-se-demo-chintan/ebs-volume/aws"
  version = "1.4.0"

  instance_id = module.ec2_instance.id[0]
  size = 30
}
