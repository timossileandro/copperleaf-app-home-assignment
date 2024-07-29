# ECR
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.env}-${var.company}-${var.app}-ecr-01"
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
  }
  tags = local.tags
}

# ECS
resource "aws_ecs_cluster" "ecs" {
  name = "${var.env}-${var.company}-${var.app}-ecs-01"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = local.tags
}

resource "aws_ecs_service" "nginx_service" {
  name            = "${var.env}-${var.company}-${var.app}-service-01"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_a.id, aws_subnet.private_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.nat_tg.arn
    container_name   = "${var.env}-${var.company}-${var.app}-nginx-01"
    container_port   = 80
  }
  tags = local.tags
}

resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "${var.env}-${var.company}-${var.app}-nginx-task-01"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "${var.env}-${var.company}-${var.app}-nginx-01"
    image     = "${aws_ecr_repository.ecr.repository_url}:${var.ecr_docker_image}"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.nginx_log_group.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "nginx"
      }
    }
  }])
  tags = local.tags
}