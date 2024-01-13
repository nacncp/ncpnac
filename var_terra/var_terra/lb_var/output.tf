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

