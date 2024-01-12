output "public_ip" {
  value       = aws_instance.rising_ec2-pub1.public_ip
  description = "The public IP of the Instance"
}

output "public_dns" {
  value       = aws_instance.rising_ec2-pub1.public_dns
  description = "The Public dns of the Instance"
}

output "private_ip" {
  value       = aws_instance.rising_ec2-pub1.private_ip
  description = "The Private_ip of the Instance"
}

output "public_ip2" {
  value       = aws_instance.rising_ec2-pub2.public_ip
  description = "The public IP of the Instance"
}
