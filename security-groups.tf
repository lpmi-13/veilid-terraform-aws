resource "aws_security_group" "veilid-group" {
  name        = "veilid security group"
  description = "Allow SSH to instance and veilid traffic on 5150/5151"
  vpc_id      = aws_vpc.veilid-vpc.id

  tags = {
    Name = "veilid-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_veilid_egress_all" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "allow all packets out"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5150_tcp" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5150
  ip_protocol       = "tcp"
  to_port           = 5150

  tags = {
    Name = "allow tcp ingress 5150"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5150_udp" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5150
  ip_protocol       = "udp"
  to_port           = 5150

  tags = {
    Name = "allow udp ingress 5150"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5151_tcp" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5151
  ip_protocol       = "tcp"
  to_port           = 5151

  tags = {
    Name = "allow tcp ingress 5151"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5151_udp" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5151
  ip_protocol       = "udp"
  to_port           = 5151

  tags = {
    Name = "allow udp ingress 5151"
  }
}
