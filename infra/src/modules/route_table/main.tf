resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = var.default_route.gateway_id
    nat_gateway_id = var.default_route.nat_gateway_id
  }
}

resource "aws_route_table_association" "main" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.main.id
}
