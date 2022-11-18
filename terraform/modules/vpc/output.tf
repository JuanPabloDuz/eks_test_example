output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnet_public" {
  value = [aws_subnet.public[0].id, aws_subnet.public[1].id, aws_subnet.public[2].id
  ]
}