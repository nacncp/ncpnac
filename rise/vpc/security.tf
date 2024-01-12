#vpc.tf
#퍼블릭 보안 그룹
resource "aws_security_group" "rising-pub-SG" {
    vpc_id = aws_vpc.rising-vpc.id
    name = "rising-pub-SG"
    description = "rising -pub-SG"
    tags = {
        Name = "rising-pub-SG"
    }

}
#퍼블릭 보안 그룹 규칙
resource "aws_security_group_rule" "rising-pub-SGRulesHTTPingress" {
    type = "ingress"
    from_port = 80
    to_port=80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.rising-pub-SG.id
    lifecycle{
        create_before_destroy = true
    }
}
resource "aws_security_group_rule" "rising-pub-SGRulesSSHingress" {
    type = "ingress"
    from_port = 22
    to_port= 22
    protocol = "TCP"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.rising-pub-SG.id
    lifecycle{
        create_before_destroy = true
    }
}
resource "aws_security_group_rule" "rising-pub-SGRulesALLegress" {
    type = "egress"
    from_port = 0
    to_port= 0
    protocol = "ALL"
    cidr_blocks=["0.0.0.0/0"]
    security_group_id = aws_security_group.rising-pub-SG.id
    lifecycle{
        create_before_destroy = true
    }
}
#프라이빗 보안 그룹
resource "aws_security_group" "rising-pri-SG" {
    vpc_id = aws_vpc.rising-vpc.id
    name = "rising-pri-SG"
    description = "rising-pri-SG"
    tags = {
        Name = "rising-pri-SG"
    }
}
#프라이빗 보안 그룹 규칙
resource "aws_security_group_rule" "rising-pri-SGRulesRDSingress" {
    type = "ingress"
    from_port = 3306
    to_port=3306
    protocol = "TCP"
    security_group_id = aws_security_group.rising-pri-SG.id
    source_security_group_id = aws_security_group.rising-pub-SG.id
    lifecycle{
        create_before_destroy = true
    }
}
resource "aws_security_group_rule" "rising-pri-SGRulesRDSegress" {
    type = "egress"
    from_port = 3306
    to_port= 3306
    protocol = "TCP"
    security_group_id = aws_security_group.rising-pri-SG.id
    source_security_group_id = aws_security_group.rising-pub-SG.id
    lifecycle{
        create_before_destroy = true
    }
}
