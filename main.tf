//--------------------------------------------------------------------
// Variables

provider "aws" {
  region  = "us-west-2"
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
  vpc_security_group_ids = "${module.security_group.this_security_group_id}"
}

module "security_group" {
  source  = "app.terraform.io/hc-se-demo-chintan/security-group/aws"
  version = "3.23.0"

  create = "true"
  description = "testing security group"
  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_rules = ["https-tcp"]
  ingress_with_cidr_blocks = [
	{
	      	from_port   = 8080
		to_port     = 8090
		protocol    = "tcp"
		description = "User-service ports"
		cidr_blocks = "10.10.0.0/16"
	}
  ]
  name = "test-sg-cgosalia"
  vpc_id = "vpc-00e43c5433b4eb92c"
}
