resource "tls_private_key" "rising_make_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "rising_make_keypair" {
  key_name   = "rising_key"
  public_key = tls_private_key.rising_make_key.public_key_openssh
}

resource "local_file" "rising_downloads_key" {
  filename = "rising_key.pem"
  content  = tls_private_key.rising_make_key.private_key_pem
}



#ec2.tf
resource "aws_instance" "rising_ec2-pub1" {
    ami = "ami-0ee4f2271a4df2d7d"
    #Amazon Linux2023 AMI
    instance_type = "t2.micro"
    security_groups = [aws_security_group.rising-pub-SG.id]
    subnet_id = aws_subnet.rising-pub-sub1.id
    key_name = aws_key_pair.rising_make_keypair.key_name
    root_block_device { #볼륨 설정 가능
			volume_size = 8
			volume_type = "gp3"
    }
    user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl enable --now httpd
              echo "Hello, Terraform" > /var/www/html/index.html
              EOF
    tags ={ #이름 설정 가능
			Name = "rising_ec2-pub1"
    }
}
resource "aws_instance" "rising_ec2-pub2" {
    ami = "ami-0ee4f2271a4df2d7d"
    #Amazon Linux2023 AMI
    instance_type = "t2.micro"
    security_groups = [aws_security_group.rising-pub-SG.id]
    subnet_id = aws_subnet.rising-pub-sub2.id
    key_name = aws_key_pair.rising_make_keypair.key_name
    root_block_device { #볼륨 설정 가능
			volume_size = 8
			volume_type = "gp3"
    }
    user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl enable --now httpd
              echo "Hello, Terraform" > /var/www/html/index.html
              EOF
    tags ={ #이름 설정 가능
			Name = "rising_ec2-pub2"
    }
}
resource "aws_instance" "rising_ec2-pri1" {
    ami = "ami-0ee4f2271a4df2d7d"
    #Amazon Linux2023 AMI
    instance_type = "t2.micro"
    security_groups = [aws_security_group.rising-pri-SG.id]
    subnet_id = aws_subnet.rising-pri-sub1.id
    key_name = aws_key_pair.rising_make_keypair.key_name
    root_block_device { #볼륨 설정 가능
			volume_size = 8
			volume_type = "gp3"
    }
    tags ={ #이름 설정 가능
			Name = "rising_ec2-pri1"
    }
}
resource "aws_instance" "rising_ec2-pri2" {
    ami = "ami-0ee4f2271a4df2d7d"
    #Amazon Linux2023 AMI
    instance_type = "t2.micro"
    security_groups = [aws_security_group.rising-pri-SG.id]
    subnet_id = aws_subnet.rising-pri-sub2.id
    key_name = aws_key_pair.rising_make_keypair.key_name
    root_block_device { #볼륨 설정 가능
			volume_size = 8
			volume_type = "gp3"
    }
    tags ={ #이름 설정 가능
			Name = "rising_ec2-pri2"
    }
}
