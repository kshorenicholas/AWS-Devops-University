terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/credentials"
}

// improvements to make:
// mechanism to look for AMI
// migrate to ec2-vpc
// mechanism to scale, manage, monitor instances 
// up & downtime scheduler
// hardware acceleration for specialized workload
// ansible roles for different OS
// fallback mechanism

resource "aws_security_group" "student_sg" { //only for ssh access from outside
  name = "student_sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_public_access_key" { // generate own key -> push to server
  key_name   = "aws_public_key"
  public_key = file("~/.ssh/trial.pub")
}

resource "aws_instance" "trial-server" {
  ami             = var.ami["ubuntu_focal"]
  instance_type   = "t2.micro"
  count           = var.machine_number
  security_groups = ["student_sg"]
  key_name        = aws_key_pair.my_public_access_key.key_name

  tags = {
    name = "trial-server.${count.index}"
  }

  provisioner "remote-exec" {
    inline = ["echo 'hello world'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.public_ip
      private_key = file("${var.private_key_path}")
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.private_key_path} ${var.ansible_location}"
  }

  /*  // use in event local-exec not working
  provisioner "remote-exec" {
    inline = [
      "mkdir /home/${var.ssh_user}/files",
      "mkdir /home/${var.ssh_user}/ansible",
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.public_ip
      private_key = file("${var.private_key_path}")
    }
  }

  provisioner "file" {
    source      = "../../ansible/software.yaml"
    destination = "/home/${var.ssh_user}/ansible/software.yaml"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.public_ip
      private_key = file("${var.private_key_path}")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible -y",
      "cd ansible; ansible-playbook -c local -i \"localhost,\" software.yaml",
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      host        = self.public_ip
      private_key = file("${var.private_key_path}")
    }
  } */
}