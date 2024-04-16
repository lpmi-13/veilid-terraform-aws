
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
  ipv6_address_count          = 1

  user_data_base64 = base64encode(file("./setup-veilid.yaml"))

  key_name = aws_key_pair.node-access.key_name

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp3"
  }

  metadata_options {
    # make sure the instance metadata service uses version 2 (requires session tokens for authenticated requests)
    http_tokens = "required"
  }

  vpc_security_group_ids = [aws_security_group.veilid-group.id]

  tags = {
    Name = "Veilid-Node-${count.index}"
  }
}

resource "aws_key_pair" "node-access" {
  key_name   = "veilid-key"
  public_key = file("FILEPATH_TO_YOUR_PUBLIC_SSH_KEY")
}
