#////////////////////////////////
#  Variables
#////////////////////////////////
variable "web_app_name" {
  type = string
}
variable "whitelist" {
  type = list(string)
}
variable "web_instance_type" {
  type = string
}
variable "web_key_name" {
  type = string
}

#//////////////////////////////
#       resouce ec2
#//////////////////////////////
resource "aws_instance" "airflow" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.web_instance_type
  key_name        = var.web_key_name
  security_groups = [aws_security_group.aws_jenkins.name]

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get -y install ansible
sudo apt-get -y install git
mkdir /home/baseConfig
cd /home/baseConfig/
git clone https://github.com/DataOpsBAR/airflow-for-end2end.git
mv airflow-for-end2end/* ./
rm -R airflow-for-end2end 
ansible-playbook airflow-playbook.yaml
   EOF
  tags = {
    Terraform = "true"
    Name      = "airflow"
  }
}

output "aws_instance_airflow" {

  value       = aws_instance.airflow.public_ip
  description = "airflow public ip "
}
output "aws_instance_airflow_dns" {

  value       = aws_instance.airflow.public_dns
  description = "airflow public dns "
}
