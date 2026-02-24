# Security group to allow SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_terraform"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = var.public_key
}

# EC2 instance
resource "aws_instance" "ec2_example" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.terraform_key.key_name

  tags = {
    Name = "Terraform-EC2-IDE"
  }
}
