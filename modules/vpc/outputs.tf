output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "eb_instance_sg_id" {
  value = aws_security_group.eb_instance_sg.id
}
