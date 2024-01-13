
#로드밸런서생성
resource "aws_alb" "create_alb" {
  name                             = "${var.pnoun}-alb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.create_pub_SG.id]
  subnets                          = aws_subnet.create_pub_sub.*.id
  enable_cross_zone_load_balancing = true
}
#타겟그룹생성
resource "aws_alb_target_group" "create_alb_tg" {
  name     = "${var.pnoun}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.create_vpc.id
#헬스체크
 health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
#타겟그룹 붙이기
resource "aws_alb_target_group_attachment" "Instance" {
  count = length(aws_instance.create_ec2_pub)
  target_group_arn = aws_alb_target_group.create_alb_tg.arn
  target_id        = "${element(aws_instance.create_ec2_pub.*.id, count.index)}"
  port             = 80
}
#로벨 리스너
resource "aws_alb_listener" "create_alb_lis" {
  load_balancer_arn = aws_alb.create_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.create_alb_tg.arn
  }
}
 # asg.tf
resource "aws_launch_configuration" "create-lc" {
  name_prefix = "${var.pnoun}-lc"
  image_id      = "ami-0ee4f2271a4df2d7d"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.create_make_keypair.key_name
  security_groups             = [aws_security_group.create_pub_SG.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f  &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "create-acg" {
  name                      = "${var.pnoun}-acg"
  min_size                  = 2
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  target_group_arns         = [aws_alb_target_group.create_alb_tg.arn]
  launch_configuration      = aws_launch_configuration.create-lc.name
  vpc_zone_identifier       = aws_subnet.create_pub_sub.*.id
}
