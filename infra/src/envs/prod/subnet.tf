resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = var.aws_az[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)

  tags = {
    Name = "${local.subnet_public_name}-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = var.aws_az[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, length(aws_subnet.public) + count.index)

  tags = {
    Name = "${local.subnet_private_name}-${count.index + 1}"
  }
}