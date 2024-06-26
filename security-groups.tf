resource "aws_security_group" "veilid-group" {
  name        = "veilid security group"
  description = "Allow SSH to instance and veilid traffic on 5150"
  vpc_id      = aws_vpc.veilid-vpc.id

  tags = {
    Name = "veilid-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  count             = local.needIpv4 ? 1 : 0
  description       = "allow ssh via ipv4"
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "allow-ssh-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  description       = "allow ssh via ipv6"
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv6         = "::/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "allow-ssh-ipv6"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_veilid_egress_all_ipv4" {
  count             = local.needIpv4 ? 1 : 0
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "allow all packets out - ipv4"

  tags = {
    Name = "allow all packets out - ipv4"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_veilid_egress_all_ipv6" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"

  description = "allow all packets out - ipv6"

  tags = {
    Name = "allow all packets out - ipv6"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5150_tcp_ipv4" {
  count             = local.needIpv4 ? 1 : 0
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5150
  ip_protocol       = "tcp"
  to_port           = 5150

  description = "allow tcp ingress 5150 - ipv4"

  tags = {
    Name = "allow tcp ingress 5150 - ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5150_udp_ipv4" {
  count             = local.needIpv4 ? 1 : 0
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5150
  ip_protocol       = "udp"
  to_port           = 5150

  description = "allow udp ingress 5150 - ipv4"

  tags = {
    Name = "allow udp ingress 5150 - ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5150_tcp_ipv6" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv6         = "::/0"
  from_port         = 5150
  ip_protocol       = "tcp"
  to_port           = 5150

  description = "allow tcp ingress 5150 - ipv6"

  tags = {
    Name = "allow tcp ingress 5150 - ipv6"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_veilid_ingress_5150_udp_ipv6" {
  security_group_id = aws_security_group.veilid-group.id
  cidr_ipv6         = "::/0"
  from_port         = 5150
  ip_protocol       = "udp"
  to_port           = 5150

  description = "allow udp ingress 5150 - ipv6"

  tags = {
    Name = "allow udp ingress 5150 - ipv6"
  }
}
