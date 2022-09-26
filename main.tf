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


resource "aws_security_group" "aws_jenkins" {
  name        = "jenkins"
  description = "Allow standard http and https ports inbount and everything outbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelist
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}
