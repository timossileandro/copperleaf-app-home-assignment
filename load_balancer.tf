# Network Load Balancer
resource "aws_lb" "nat_lb" {
  name                       = "${var.env}-${var.company}-${var.app}-nlb-01"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  enable_deletion_protection = false
  tags                       = local.tags
}

resource "aws_lb_target_group" "nat_tg" {
  name     = "${var.env}-${var.company}-${var.app}-nlb-tg-01"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port                = "80"
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
  }

  target_type = "ip"
  tags        = local.tags
}

resource "aws_lb_listener" "nat_listener" {
  load_balancer_arn = aws_lb.nat_lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nat_tg.arn
  }
  tags = local.tags
}

resource "aws_lb_target_group_attachment" "nat1" {
  target_group_arn = aws_lb_target_group.nat_tg.arn
  target_id        = aws_nat_gateway.ngwa.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "nat2" {
  target_group_arn = aws_lb_target_group.nat_tg.arn
  target_id        = aws_nat_gateway.ngwb.private_ip
  port             = 80
}