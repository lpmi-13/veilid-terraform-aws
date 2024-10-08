
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
  instance_type = "t4g.nano"

  user_data_base64 = base64encode(file("./setup-veilid.yaml"))

  key_name = aws_key_pair.node-access.key_name

  volume_tags = {
    "Name" = "Veilid storage for Node-${count.index}"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp3"
  }

  # we explicitly specify the index to be 0 so that an extra default network interface doesn't get created
  # (which happens by default unless you do this), and then we have 2 network interfaces and things get confusing
  network_interface {
    network_interface_id = aws_network_interface.veilid-interface[count.index].id
    device_index         = 0
  }

  metadata_options {
    # make sure the instance metadata service uses version 2 (requires session tokens for authenticated requests)
    http_tokens = "required"
  }

  lifecycle {
    # Don't automatically upgrade the instance when a newer AMI is released. Because we use `most_recent = true`
    # in the data source, if you run apply after a newer AMI is released, it will trigger a destroy and recreate
    # of the instance, which will wipe all the DHT data.
    ignore_changes = [ami]
  }

  tags = {
    Name = "Veilid-Node-${count.index}"
  }
}

resource "aws_key_pair" "node-access" {
  key_name   = "veilid-key"
  public_key = file("FILEPATH_TO_YOUR_PUBLIC_SSH_KEY")
}
