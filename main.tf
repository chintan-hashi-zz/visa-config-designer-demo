module "ec2_instance" {
  source  = "app.terraform.io/hc-se-demo-chintan/ec2-instance/aws"
  version = "2.18.0"

  ami = "ami-059fd73d4594fa21c"
  instance_type = "t2.medium"
  key_name = "cgosalia-aws-key"
  name = "cgosalia-vault-test1"
  subnet_id = "subnet-024d03616522c6a61"
  vpc_security_group_ids = "sg-049cb0ce979def91b"
}
