module "public_route_table" {
  source = "../../../modules/route_table"

  vpc_id     = aws_vpc.main.id
  subnet_ids = [for s in aws_subnet.public : s.id]

  default_route = {
    gateway_id = aws_internet_gateway.main.id
  }
}

module "private_route_table" {
  source = "../../../modules/route_table"

  vpc_id     = aws_vpc.main.id
  subnet_ids = [for s in aws_subnet.private : s.id]

  default_route = {
    nat_gateway_id = aws_nat_gateway.main.id
  }
}
