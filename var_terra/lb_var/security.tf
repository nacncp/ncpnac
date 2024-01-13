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

