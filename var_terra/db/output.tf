output "public_ip" {
  value       = aws_instance.create_ec2_pub.*.public_ip
  description = "The public IP of the Instance"
}
output "public_private_ip" {
  value       = aws_instance.create_ec2_pub.*.private_ip
  description = "The Private_ip of the Instance"
}
output "public_dns" {
  value       = aws_instance.create_ec2_pub.*.public_dns
  description = "The Public dns of the Instance"
}
output "private_ip" {
  value       = aws_instance.create_ec2_pri.*.private_ip
  description = "The Private_ip of the Instance"
}
output "nat_gateway_ip" {
  value       = ["${aws_eip.create-eip.*.public_ip}"]
  description = "The Private_ip of the Instance"
}
output "alb_dns" {
  value       = aws_alb.create_alb.*.dns_name
  description = "The Public dns of the alb"
}
output "rds_writer_endpoint" { # rds cluster의 writer 인스턴스 endpoint 추출 (mysql 설정 및 Three-tier 연동파일에 정보 입력 필요해서 추출)
  value = aws_rds_cluster.create-aurora-mysql-db.endpoint # 해당 추출값은 terraform apply 완료 시 또는 terraform output rds_writer_endpoint로 확인 가능
}
