output "aws_instance_airflow" {

  value       = aws_instance.airflow.public_ip
  description = "airflow public ip "
}
output "aws_instance_airflow_dns" {

  value       = aws_instance.airflow.public_dns
  description = "airflow public dns "
}
