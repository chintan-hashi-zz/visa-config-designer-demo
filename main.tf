//--------------------------------------------------------------------
// Variables

provider "aws" {
  region  = "us-west-1"
}

//--------------------------------------------------------------------
// Modules


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
  version = "3.28.0"

  cidr_block = ["0.0.0.0/0"]
  description = "TLS traffic"
  from_port = 8080
  name = "tls-sg-cgosalia"
  protocol = "TCP"
  rule_description = "allowing TLS traffic"
  to_port = 8090
  vpc_id = "vpc-00e43c5433b4eb92c"
}
