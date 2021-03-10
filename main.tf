//--------------------------------------------------------------------
// Variables

provider "aws" {
  region  = "us-west-1"
}

//--------------------------------------------------------------------
// Modules
module "ec2_instance" {
  source  = "app.terraform.io/hc-se-demo-chintan/ec2-instance/aws"
  version = "2.19.0"

  ami = "ami-059fd73d4594fa21c"
  instance_type = "t2.medium"
  key_name = "cgosalia-aws-key"
  name = "cgosalia-vault-test1"
  subnet_id = "subnet-024d03616522c6a61"
  vpc_security_group_ids = tolist([${module.security_group.this_security_group_id}, ${module.security_group_2.this_security_group_id}])
}

module "elb" {
  source  = "app.terraform.io/hc-se-demo-chintan/elb/aws"
  version = "2.4.3"

  instances = tolist(module.ec2_instance.id)
  internal = "false"
  name = "cgosalia-elb-vault"
}

module "security_group" {
  source  = "app.terraform.io/hc-se-demo-chintan/security-group/aws"
  version = "3.28.0"

  cidr_block = ["0.0.0.0/0"]
  description = "vault security group"
  from_port = 80
  name = "cgosalia-visa-vault-sg-group"
  protocol = "TCP"
  rule_description = "vault security group"
  to_port = 8201
  vpc_id = "vpc-00e43c5433b4eb92c"
}

module "security_group_2" {
  source  = "app.terraform.io/hc-se-demo-chintan/security-group/aws"
  version = "3.28.0"

  cidr_block = ["0.0.0.0/0"]
  description = "day2 security group"
  from_port = 90
  name = "cgosalia-day2-sg"
  protocol = "UDP"
  rule_description = "day 2 security group"
  to_port = 100
  vpc_id = "vpc-00e43c5433b4eb92c"
}
