output "aws_customer_gateway_main_id" {
  value       = aws_customer_gateway.main.id
  description = "The amazon-assigned ID of the main customer gateway"
}

output "aws_customer_gateway_main_arn" {
  value       = aws_customer_gateway.main.arn
  description = "The ARN of the main customer gateway"
}

output "aws_customer_gateway_backup_id" {
  value       = aws_customer_gateway.backup.id
  description = "The amazon-assigned ID of the backup customer gateway"
}

output "aws_customer_gateway_backup_arn" {
  value       = aws_customer_gateway.backup.arn
  description = "The ARN of the backup customer gateway"
}

output "aws_vpn_connection_main_id" {
  value       = aws_vpn_connection.main.id
  description = "The amazon-assigned ID of the main VPN connection"
}

output "aws_vpn_connection_main_arn" {
  value       = aws_vpn_connection.main.arn
  description = "The ARN of the main VPN connection"
}

output "aws_vpn_connection_main_customer_gateway_id" {
  value       = aws_vpn_connection.main.customer_gateway_id
  description = "The ID of the customer gateway to which the main VPN connection is attached."
}

output "aws_vpn_connection_main_transit_gateway_attachment_id" {
  value       = aws_vpn_connection.main.transit_gateway_attachment_id
  description = "When associated with an EC2 Transit Gateway (transit_gateway_id argument), the attachment ID."
}

output "aws_vpn_connection_main_tunnel1_address" {
  value       = aws_vpn_connection.main.tunnel1_address
  description = "For the Main VPN, The public IP address of the first tunnel."
}

output "aws_vpn_connection_main_tunnel1_cgw_inside_address" {
  value       = aws_vpn_connection.main.tunnel1_cgw_inside_address
  description = "For the Main VPN, The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)."
}

output "aws_vpn_connection_main_tunnel1_vgw_inside_address" {
  value       = aws_vpn_connection.main.tunnel1_vgw_inside_address
  description = "For the Main VPN, The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)."
}

output "aws_vpn_connection_main_tunnel1_preshared_key" {
  description = "For the Main VPN, The preshared key of the first VPN tunnel."
  value       = aws_vpn_connection.main.tunnel1_preshared_key
}

output "aws_vpn_connection_main_tunnel1_bgp_asn" {
  description = "For the Main VPN, The bgp asn number of the first VPN tunnel."
  value       = aws_vpn_connection.main.tunnel1_bgp_asn
}

output "aws_vpn_connection_main_tunnel1_bgp_holdtime" {
  description = "For the Main VPN, The bgp holdtime of the first VPN tunnel."
  value       = aws_vpn_connection.main.tunnel1_bgp_holdtime
}

output "aws_vpn_connection_main_tunnel2_address" {
  description = "For the Main VPN, The public IP address of the second tunnel."
  value       = aws_vpn_connection.main.tunnel2_address
}

output "aws_vpn_connection_main_tunnel2_cgw_inside_address" {
  description = "For the Main VPN, The RFC 6890 link-local address of the second VPN tunnel. (Customer Gateway Side)."
  value       = aws_vpn_connection.main.tunnel2_cgw_inside_address
}

output "aws_vpn_connection_main_tunnel2_preshared_key" {
  description = "For the Main VPN, The preshared key of the second VPN tunnel."
  value       = aws_vpn_connection.main.tunnel2_preshared_key
}

output "aws_vpn_connection_main_tunnel2_bgp_asn" {
  description = "For the Main VPN, The bgp asn number of the second VPN tunnel."
  value       = aws_vpn_connection.main.tunnel2_bgp_asn
}

output "aws_vpn_connection_main_tunnel2_bgp_holdtime" {
  description = "For the Main VPN, The bgp holdtime of the second VPN tunnel."
  value       = aws_vpn_connection.main.tunnel2_bgp_holdtime
}

output "aws_vpn_connection_backup_id" {
  value       = aws_vpn_connection.backup.id
  description = "The amazon-assigned ID of the backup VPN connection"
}

output "aws_vpn_connection_backup_arn" {
  value       = aws_vpn_connection.backup.arn
  description = "The ARN of the backup VPN connection"
}

output "aws_vpn_connection_backup_customer_gateway_id" {
  value       = aws_vpn_connection.backup.customer_gateway_id
  description = "The ID of the customer gateway to which the backup VPN connection is attached."
}

output "aws_vpn_connection_backup_transit_gateway_attachment_id" {
  value       = aws_vpn_connection.backup.transit_gateway_attachment_id
  description = "When associated with an EC2 Transit Gateway (transit_gateway_id argument), the attachment ID."
}

output "aws_vpn_connection_backup_tunnel1_address" {
  value       = aws_vpn_connection.backup.tunnel1_address
  description = "For the backup VPN, The public IP address of the first tunnel."
}

output "aws_vpn_connection_backup_tunnel1_cgw_inside_address" {
  value       = aws_vpn_connection.backup.tunnel1_cgw_inside_address
  description = "For the backup VPN, The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)."
}

output "aws_vpn_connection_backup_tunnel1_vgw_inside_address" {
  value       = aws_vpn_connection.backup.tunnel1_vgw_inside_address
  description = "For the backup VPN, The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)."
}

output "aws_vpn_connection_backup_tunnel1_preshared_key" {
  description = "For the backup VPN, The preshared key of the first VPN tunnel."
  value       = aws_vpn_connection.backup.tunnel1_preshared_key
}

output "aws_vpn_connection_backup_tunnel1_bgp_asn" {
  description = "For the backup VPN, The bgp asn number of the first VPN tunnel."
  value       = aws_vpn_connection.backup.tunnel1_bgp_asn
}

output "aws_vpn_connection_backup_tunnel1_bgp_holdtime" {
  description = "For the backup VPN, The bgp holdtime of the first VPN tunnel."
  value       = aws_vpn_connection.backup.tunnel1_bgp_holdtime
}

output "aws_vpn_connection_backup_tunnel2_address" {
  description = "For the backup VPN, The public IP address of the second tunnel."
  value       = aws_vpn_connection.backup.tunnel2_address
}

output "aws_vpn_connection_backup_tunnel2_cgw_inside_address" {
  description = "For the backup VPN, The RFC 6890 link-local address of the second VPN tunnel. (Customer Gateway Side)."
  value       = aws_vpn_connection.backup.tunnel2_cgw_inside_address
}

output "aws_vpn_connection_backup_tunnel2_preshared_key" {
  description = "For the backup VPN, The preshared key of the second VPN tunnel."
  value       = aws_vpn_connection.backup.tunnel2_preshared_key
}

output "aws_vpn_connection_backup_tunnel2_bgp_asn" {
  description = "For the backup VPN, The bgp asn number of the second VPN tunnel."
  value       = aws_vpn_connection.backup.tunnel2_bgp_asn
}

output "aws_vpn_connection_backup_tunnel2_bgp_holdtime" {
  description = "For the backup VPN, The bgp holdtime of the second VPN tunnel."
  value       = aws_vpn_connection.backup.tunnel2_bgp_holdtime
}