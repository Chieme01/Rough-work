resource "aws_ec2_transit_gateway_route" "tgwroute" {
    for_each = toset(local.cidrs)
  destination_cidr_block         = each.value
  blackhole                      = true
  transit_gateway_route_table_id = local.tgwroutetables[0]
}