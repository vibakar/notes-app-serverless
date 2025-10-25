resource "aws_ecs_cluster" "notes_app" {
  name = var.app_name
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "${var.app_name}-frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "frontend"
    image = var.frontend_image
    repositoryCredentials = {
      credentialsParameter = "${data.terraform_remote_state.bootstrap.outputs.docker_secret.arn}"
    }
    portMappings = [{
      containerPort = 80
    }]
    environment = [
      { name = "VITE_API_BASE_URL", value = "https://${local.backend_domain_name}" },
      { name = "VITE_AUTH0_REDIRECT_URI", value = "https://${local.frontend_domain_name}" }
    ]
    secrets = [
      {
        name      = "VITE_AUTH0_DOMAIN"
        valueFrom = "${data.terraform_remote_state.auth0.outputs.auth0_secret.arn}:AUTH0_DOMAIN::"
      },
      {
        name      = "VITE_AUTH0_AUDIENCE"
        valueFrom = "${data.terraform_remote_state.auth0.outputs.auth0_secret.arn}:AUTH0_AUDIENCE::"
      },
      {
        name      = "VITE_AUTH0_CLIENT_ID"
        valueFrom = "${data.terraform_remote_state.auth0.outputs.auth0_secret.arn}:AUTH0_CLIENT_ID::"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "frontend"
      }
    }
  }])
}

resource "aws_ecs_service" "frontend" {
  name                   = "frontend"
  cluster                = aws_ecs_cluster.notes_app.id
  task_definition        = aws_ecs_task_definition.frontend.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_blue_tg.arn
    container_name   = "frontend"
    container_port   = 80
  }

  propagate_tags = "SERVICE"

  depends_on = [aws_lb_listener.https]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}
