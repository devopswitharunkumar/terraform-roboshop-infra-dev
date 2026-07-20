
#!/bin/bash
set -e

component=$1
environment=$2

dnf install -y python3 python3-pip python3-boto3 python3-botocore git ansible

# Install RabbitMQ Ansible collection only for rabbitmq component
if [ "$component" == "rabbitmq" ]
then
    echo "Installing RabbitMQ Ansible collection..."
    ansible-galaxy collection install community.rabbitmq
else
    echo "RabbitMQ collection not required for $component"
fi

###########we are implememting pull based architecture for databases########

ansible-pull -U https://github.com/devopswitharunkumar/roboshop-ansible-with-roles-for-terraform-infra-usage.git -e component=$component -e env=$environment main-tf.yaml

