
resource "aws_vpc" "veilid-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Veilid-VPC"
  }
}

resource "aws_subnet" "veilid-subnet" {
  vpc_id     = aws_vpc.veilid-vpc.id
  cidr_block = "10.0.1.0/24"

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
  count     = local.instance_count
  subnet_id = aws_subnet.veilid-subnet.id

  attachment {
    instance     = aws_instance.veilid-node[count.index].id
    device_index = 1
  }
}

resource "aws_route_table" "veilid-routes" {
  vpc_id = aws_vpc.veilid-vpc.id

  tags = {
    Name = "veilid-routes"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.veilid-routes.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.veilid-gw.id
}

resource "aws_route_table_association" "public-gateway" {
  subnet_id      = aws_subnet.veilid-subnet.id
  route_table_id = aws_route_table.veilid-routes.id
}
