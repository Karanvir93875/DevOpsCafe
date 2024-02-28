resource "aws_ecs_task_definition" "app" {
  family                   = "devops-cafe-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "590184135583.dkr.ecr.us-east-1.amazonaws.com/myregistry"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        },
      ]
    },
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "devops-cafe-service"
  cluster         = aws_ecs_cluster.devops_cafe_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = ["subnet-061f6d63fe9cfc86a"]
    security_groups = ["sg-026ca46e2b30920d0"]
    assign_public_ip = true
  }
}
