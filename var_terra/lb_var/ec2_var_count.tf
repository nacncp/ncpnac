#pem키 생성
resource "tls_private_key" "create_make_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "create_make_keypair" {
  key_name   = "${var.pnoun}_key"
  public_key = tls_private_key.create_make_key.public_key_openssh
}
resource "local_file" "create_downloads_key" {
  filename = "${var.pnoun}_key.pem"
  content  = tls_private_key.create_make_key.private_key_pem
}


#ec2.tf
#ec2 web서버
resource "aws_instance" "create_ec2_pub" {
    count = length(aws_subnet.create_pub_sub)
    ami = "ami-0ee4f2271a4df2d7d"
    #Amazon Linux2023 AMI
    instance_type = "t2.micro"
    security_groups = [aws_security_group.create_pub_SG.id]
    subnet_id ="${element(aws_subnet.create_pub_sub.*.id, count.index)}"
    key_name = aws_key_pair.create_make_keypair.key_name
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
			Name = "${var.pnoun}_ec2_pub${count.index+1}"
    }
}

resource "aws_instance" "create_ec2_pri" {
    count = length(aws_subnet.create_pri_sub)
    ami = "ami-0ee4f2271a4df2d7d"
    #Amazon Linux2023 AMI
    instance_type = "t2.micro"
    security_groups = [aws_security_group.create_pri_SG.id]
    subnet_id = "${element(aws_subnet.create_pri_sub.*.id, count.index)}"
    key_name = aws_key_pair.create_make_keypair.key_name
    root_block_device { #볼륨 설정 가능
			volume_size = 8
			volume_type = "gp3"
    }
    tags ={ #이름 설정 가능
			Name = "${var.pnoun}_ec2_pri${count.index+1}"
    }
}
