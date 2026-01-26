export const awsCommand = `aws ec2 describe-images --owners 427812963091  --filter 'Name=name,Values=nixos/${import.meta.env.NIXOS_STABLE_SERIES}*' 'Name=architecture,Values=arm64' --query 'sort_by(Images, &CreationDate)'`;
// prettier-ignore-start
export const aweTerraform = `provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "nixos_arm64" {
  owners = ["427812963091"]
  most_recent = true

  filter {
    name   = "name"
    values = ["nixos/${import.meta.env.NIXOS_STABLE_SERIES}*"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"] # or "x86_64"
  }
}

resource "aws_instance" "nixos_arm64" {
  ami = data.aws_ami.nixos_arm64.id
  instance_type = "t4g.nano"
}
`;
// prettier-ignore-end
