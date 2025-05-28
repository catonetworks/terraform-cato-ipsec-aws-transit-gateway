data "aws_ec2_transit_gateway" "this" {
  id = var.aws_transit_gateway_id
}

data "cato_allocatedIp" "primary" {
  name_filter = [var.cato_primary_gateway_ip_address]
}

data "cato_allocatedIp" "secondary" {
  name_filter = [var.cato_secondary_gateway_ip_address]
}