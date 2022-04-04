resource "aws_key_pair" "ssh_key_pair" {
  key_name_prefix = "${var.prefix}-rancher-k3s-fleet-"
  public_key      = file("${var.ssh_key_file_name}.pub")
}

# Security group to allow all traffic
resource "aws_security_group" "sg_allowall" {
  name        = "${var.prefix}-rancher-k3s-fleet-allowall"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "x86_vms" {
  count         = 5
  ami           = data.aws_ami.sles_x86.id
  instance_type = "t3a.xlarge"

  key_name        = aws_key_pair.ssh_key_pair.key_name
  security_groups = [aws_security_group.sg_allowall.name]

  root_block_device {
    volume_size = 80
  }

  tags = {
    Name = "${var.prefix}-rancher-k3s-fleet-x86"
  }
}

resource "aws_instance" "arm_vms" {
  count         = 1
  ami           = data.aws_ami.sles_arm.id
  instance_type = "a1.medium"

  key_name        = aws_key_pair.ssh_key_pair.key_name
  security_groups = [aws_security_group.sg_allowall.name]

  root_block_device {
    volume_size = 80
  }

  tags = {
    Name = "${var.prefix}-rancher-k3s-fleet-arm"
  }
}