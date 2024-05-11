#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent3.sh | sh
systemctl start td-agent
systemctl enable td-agent
yum update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
aws ec2 modify-instance-credit-specification --instance-credit-specification "InstanceId=$(curl http://***.***.***.***/latest/meta-data/instance-id -s),CpuCredits=standard" --region ${aws_region}
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"syslog\",\"awslogs\"] >> /etc/ecs/ecs.config
echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=10m >> /etc/ecs/ecs.config
echo ECS_CONTAINER_STOP_TIMEOUT=30s >> /etc/ecs/ecs.config
echo ECS_CONTAINER_START_TIMEOUT=3m >> /etc/ecs/ecs.config
echo ECS_DISABLE_IMAGE_CLEANUP=false >> /etc/ecs/ecs.config
echo ECS_IMAGE_CLEANUP_INTERVAL=10m >> /etc/ecs/ecs.config
echo ECS_IMAGE_MINIMUM_CLEANUP_AGE=15m >> /etc/ecs/ecs.config
echo ECS_NUM_IMAGES_DELETE_PER_CYCLE=10 >> /etc/ecs/ecs.config
