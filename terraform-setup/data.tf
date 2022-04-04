data "aws_ami" "sles_x86" {
  owners      = ["013907871322"]
  most_recent = true

  filter {
    name   = "name"
    values = ["suse-sles-15-sp2*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "sles_arm" {
  owners      = ["013907871322"]
  most_recent = true

  filter {
    name   = "name"
    values = ["suse-sles-15-sp2*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}