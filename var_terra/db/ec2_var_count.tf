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

# RDS -> 옵션 많음
resource "aws_rds_cluster" "create-aurora-mysql-db" {
  cluster_identifier = "${var.pnoun}-db" # RDS Cluster 식별자명
  engine_mode = "provisioned" # DB 인스턴스 생성 시 Provisioned(미설정 시 default) 또는 Serverless 모드 지정
  db_subnet_group_name = aws_db_subnet_group.create-db-subg.name # DB가 배치될 서브넷 그룹(.name으로 지정)
  vpc_security_group_ids = [aws_security_group.create_db_SG.id] # db 보안그룹 지정
  engine = "aurora-mysql" # 엔진 유형
  engine_version = "5.7.mysql_aurora.2.11.1" # 엔진 버전
  availability_zones = var.vpc_az # 가용 영역
  database_name = "camdb" # 이름 명칭 구문 까다로움 (특수문자 들어가면 안됌)
  master_username = "pnoun" # 인스턴스에서 직접 제어되는 DB Master User Name
  master_password = "1q2w3e4r"
  skip_final_snapshot = true # RDS 삭제 시, 스냅샷 생성 X (true값으로 설정 시, terraform destroy 정상 수행 가능)
}
# RDS instance
resource "aws_rds_cluster_instance" "create-aurora-mysql-db-sv" {
  count = 2 # RDS Cluster에 속한 총 2개의 DB 인스턴스 생성 (Reader/Writer로 지정)
  identifier = "database-1-${count.index}" # Instance의 식별자명 (count index로 0번부터 1씩 상승)
  cluster_identifier = aws_rds_cluster.create-aurora-mysql-db.id # 소속될 Cluster의 ID 지정
  instance_class = "db.t3.small" # DB 인스턴스 Class (메모리 최적화/버스터블 클래스 선택 없이 type명만 적으면 됌)
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.11.1"
}
