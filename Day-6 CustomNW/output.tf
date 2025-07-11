output "instance" {
  value = aws_instance.name.id
}
output "ig" {
  value = aws_internet_gateway.name.id
}
output "route" {
  value = aws_route.name.id
}
output "rt_table" {
  value = aws_route_table.name.id
}
output "rt_subnet" {
  value = aws_route_table_association.name.id
}
output "namsecurity_group" {
  value = aws_security_group.name.id
}
output "subnet" {
  value = aws_subnet.name.id
}
output "vpc" {
  value = aws_vpc.name.id
}
