[
  {
      "name": "${name}",
      "image": "${image}:${version}",
      "memory": ${memory},
      "cpu": ${cpu},
      "essential": true,
      "linuxParameters":
          { 
            "initProcessEnabled": true
          },
      "portMappings": [
          {
              "containerPort": ${docker_port},
              "hostPort": 0,
              "protocol": "tcp"
          }
        ],
         "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${awslogs-group}",
                "awslogs-region": "${awslogs-region}",
                "awslogs-stream-prefix": "${version}"
                
            }
        }
  }
]