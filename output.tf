output "vpc_id" {
  value       = aws_vpc.ada_vpc.id
  description = "ID da VPC criada para teste da ADA"
}