data "aws_vpcs" "vpcs" {}

data "aws_subnets" "subnets" {
    filter {
        name = "vpc-id"
        values = [local.all_vpcs[0]]
    }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

locals {
    all_vpcs = data.aws_vpcs.vpcs.ids
    subnets = [for s in data.aws_subnet.subnet : s.id]
    cidrs = [for s in data.aws_subnet.subnet : s.cidr_block]
    tgwroutetables = data.aws_ec2_transit_gateway_route_tables.tgwrtbs.ids
}

/* data "aws_route_tables" "rtables" {

} */

data "aws_ec2_transit_gateway_route_tables" "tgwrtbs" {}

/* data "aws_ec2_transit_gateway_route_table" "tgwrtb" {
    for_each = toset(data.aws_ec2_transit_gateway_route_tables.tgwrtbs)
  id = each.value
}

output "tgwroutetables" {
  value = data.aws_ec2_transit_gateway_route_table.tgwrtb.ids
} */

