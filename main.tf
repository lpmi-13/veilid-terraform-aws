
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "veilid-node" {
  count         = local.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t4g.micro"

  subnet_id                   = aws_subnet.veilid-subnet.id
  associate_public_ip_address = true

  user_data_base64 = base64encode(file("./setup-veilid.yaml"))

  key_name = aws_key_pair.node-access.key_name

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp3"
  }

  vpc_security_group_ids = [aws_security_group.veilid-group.id]

  tags = {
    Name = "Veilid-Node-${count.index}"
  }
}

resource "aws_key_pair" "node-access" {
  key_name   = "veilid-key"
  public_key = file("./veilid-key.pub")
}
