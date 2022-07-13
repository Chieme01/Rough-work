/* output "rtables" {
  value = data.aws_route_tables.rtables
} */

output "subnet_cidr_blocks" {
  value = local.cidrs
}

output "tgwrtables" {
    value = data.aws_ec2_transit_gateway_route_tables.tgwrtbs
  
}

output "vpcs" {
  value = local.all_vpcs
}

/* output "tgwroutetables" {
  value = data.aws_ec2_transit_gateway_route_table.tgwrtb.ids
}
 */
