
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
