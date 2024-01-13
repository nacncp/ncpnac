#vpc.tf
#퍼블릭 보안 그룹
resource "aws_security_group" "create_pub_SG" {
    vpc_id = aws_vpc.create_vpc.id
    name = "create_pub_SG"
    description = "${var.pnoun}_pub_SG"
    tags = {
        Name = "${var.pnoun}_pub_SG"
    }

}
#퍼블릭 보안 그룹 규칙
resource "aws_security_group_rule" "create_pub_SGRulesHTTPingress" {
    type = "ingress"
    from_port = 80
    to_port=80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.create_pub_SG.id
    lifecycle{
        create_before_destroy = true
    }
}
resource "aws_security_group_rule" "create_pub_SGRulesSSHingress" {
    type = "ingress"
    from_port = 22
    to_port= 22
    protocol = "TCP"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.create_pub_SG.id
    lifecycle{
        create_before_destroy = true
    }
}
resource "aws_security_group_rule" "create_pub_SGRulesALLegress" {
    type = "egress"
    from_port = 0
    to_port= 0
    protocol = "ALL"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.create_pub_SG.id
    lifecycle{
        create_before_destroy = true
    }
}
#프라이빗 보안 그룹
resource "aws_security_group" "create_pri_SG" {
    vpc_id = aws_vpc.create_vpc.id
    name = "${var.pnoun}_pri_SG"
    description = "${var.pnoun}_pri_SG"
    tags = {
        Name = "${var.pnoun}_pri_SG"
    }
}
#프라이빗 보안 그룹 규칙
resource "aws_security_group_rule" "create_pri_SGRulesRDSingress" {
    type = "ingress"
    from_port = 3306
    to_port=3306
    protocol = "TCP"
    security_group_id = aws_security_group.create_pri_SG.id
    source_security_group_id = aws_security_group.create_pub_SG.id
    lifecycle{
        create_before_destroy = true
    }
}
resource "aws_security_group_rule" "create_pri_SGRulesRDSegress" {
    type = "egress"
    from_port = 3306
    to_port= 3306
    protocol = "TCP"
    security_group_id = aws_security_group.create_pri_SG.id
    source_security_group_id = aws_security_group.create_pub_SG.id
    lifecycle{
        create_before_destroy = true
    }
}


# DB 보안 그룹 생성
resource "aws_security_group" "create_db_SG" {
  name = "${var.pnoun}_db_SG"
  description = "${var.pnoun} database security group"
  vpc_id = aws_vpc.create_vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.create_pri_SG.id]
    # 처음에 생성한 External ALB SG를 Inbound로 허용하도록 구성
  }

  egress { # 보안 그룹 생성 시, Outbound 허용을 직접 지정해줘야 통신 가능(관리 콘솔은 자동 생성 / 테라폼은 지정 필수)
    from_port = 0
    to_port = 0
    protocol = "-1" # Protocol -1은 전체 프로토콜을 의미
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.pnoun}_db_SG"
  }
}
