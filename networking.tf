
resource "aws_vpc" "veilid-vpc" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "Veilid-VPC"
  }
}

resource "aws_subnet" "veilid-subnet" {
  vpc_id                                         = aws_vpc.veilid-vpc.id
  assign_ipv6_address_on_creation                = true
  enable_resource_name_dns_aaaa_record_on_launch = true

  cidr_block = "10.0.1.0/24"

  ipv6_cidr_block = cidrsubnet(aws_vpc.veilid-vpc.ipv6_cidr_block, 8, 1)

  tags = {
    Name = "Veilid-Subnet"
  }
}

resource "aws_internet_gateway" "veilid-gw" {
  vpc_id = aws_vpc.veilid-vpc.id

  tags = {
    Name = "veilid-internet-gateway"
  }
}

resource "aws_network_interface" "veilid-interface" {
  count           = local.instance_count
  subnet_id       = aws_subnet.veilid-subnet.id
  security_groups = [aws_security_group.veilid-group.id]
}

resource "aws_route_table" "veilid-routes" {
  vpc_id = aws_vpc.veilid-vpc.id

  tags = {
    Name = "veilid-routes"
  }
}

resource "aws_route" "public_internet_gateway_ipv6" {
  route_table_id              = aws_route_table.veilid-routes.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.veilid-gw.id
}


resource "aws_route_table_association" "public-gateway" {
  subnet_id      = aws_subnet.veilid-subnet.id
  route_table_id = aws_route_table.veilid-routes.id
}

resource "aws_route" "public_internet_gateway_ipv4" {
  count                  = local.needIpv4 ? 1 : 0
  route_table_id         = aws_route_table.veilid-routes.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.veilid-gw.id
}

resource "aws_eip" "ipv4" {
  count  = local.needIpv4 ? local.instance_count : 0
  domain = "vpc"

  network_interface = aws_network_interface.veilid-interface[count.index].id
  depends_on        = [aws_internet_gateway.veilid-gw]

  tags = {
    Name = "veilid-access-ipv4"
  }
}
