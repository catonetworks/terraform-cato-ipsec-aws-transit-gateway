## Create Customer Gateway
resource "aws_customer_gateway" "main" {
  bgp_asn     = var.cato_bgp_asn
  ip_address  = var.primary_customer_gateway_ip_address
  type        = "ipsec.1"
  device_name = "cato-networks-cloud"

  tags = merge({
    Name = "main-customer-gateway"
  }, var.tags)
}

resource "aws_customer_gateway" "backup" {
  bgp_asn     = var.cato_bgp_asn
  ip_address  = var.secondary_customer_gateway_ip_address
  type        = "ipsec.1"
  device_name = "cato-networks-cloud"

  tags = merge({
    Name = "backup-customer-gateway"
  }, var.tags)
}


resource "aws_vpn_connection" "main" {
  customer_gateway_id = aws_customer_gateway.main.id
  transit_gateway_id  = var.aws_transit_gateway_id
  type                = aws_customer_gateway.main.type
  tunnel1_inside_cidr = var.tunnel1_inside_cidr
  # tunnel2_inside_cidr   = var.tunnel2_inside_cidr
  tunnel1_preshared_key = var.tunnel1_preshared_key
  # tunnel2_preshared_key = var.tunnel2_preshared_key
  tunnel1_dpd_timeout_action      = "none"
  tunnel2_dpd_timeout_action      = "none"
  tunnel1_ike_versions            = ["ikev2"]
  tunnel2_ike_versions            = ["ikev2"]
  tunnel1_phase1_dh_group_numbers = [15]
  tunnel2_phase1_dh_group_numbers = [15]
  tunnel1_phase2_dh_group_numbers = [15]
  tunnel2_phase2_dh_group_numbers = [15]
  tunnel1_phase1_lifetime_seconds = 19800
  tunnel1_phase1_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase2_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms = ["SHA2-256"]
  tunnel1_phase2_integrity_algorithms = ["SHA2-256"]

  tags = merge({
    Name = "main-vpn-connection"
  }, var.tags)
}

resource "aws_vpn_connection" "backup" {
  customer_gateway_id = aws_customer_gateway.backup.id
  transit_gateway_id  = var.aws_transit_gateway_id
  type                = aws_customer_gateway.backup.type
  tunnel1_inside_cidr = var.tunnel2_inside_cidr
  # tunnel2_inside_cidr   = var.tunnel2_inside_cidr
  tunnel1_preshared_key = var.tunnel2_preshared_key
  # tunnel2_preshared_key = var.tunnel2_preshared_key
  tunnel1_dpd_timeout_action      = "none"
  tunnel2_dpd_timeout_action      = "none"
  tunnel1_ike_versions            = ["ikev2"]
  tunnel2_ike_versions            = ["ikev2"]
  tunnel1_phase1_dh_group_numbers = [15]
  tunnel2_phase1_dh_group_numbers = [15]
  tunnel1_phase2_dh_group_numbers = [15]
  tunnel2_phase2_dh_group_numbers = [15]
  tunnel1_phase1_lifetime_seconds = 19800
  tunnel1_phase1_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase2_encryption_algorithms = ["AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms = ["SHA2-256"]
  tunnel1_phase2_integrity_algorithms = ["SHA2-256"]


  tags = merge({
    Name = "backup-vpn-connection"
  }, var.tags)

}

resource "cato_ipsec_site" "ipsec-site" {
  name                 = var.site_name
  site_type            = var.site_type
  description          = var.site_description
  native_network_range = var.native_network_range
  site_location        = var.site_location
  ipsec = {
    primary = {
      destination_type  = var.primary_destination_type
      public_cato_ip_id = var.primary_public_cato_ip_id
      pop_location_id   = var.primary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.main.tunnel1_address
          private_cato_ip = var.primary_private_cato_ip
          private_site_ip = var.primary_private_site_ip
          psk             = var.tunnel1_preshared_key
          last_mile_bw = {
            downstream = var.downstream_bw
            upstream   = var.upstream_bw
            # downstream_mbps_precision = 1
            # upstream_mbps_precision = 1
          }
        }
      ]
    }
    secondary = {
      destination_type  = var.secondary_destination_type
      public_cato_ip_id = var.secondary_public_cato_ip_id
      pop_location_id   = var.secondary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.backup.tunnel1_address
          private_cato_ip = var.secondary_private_cato_ip
          private_site_ip = var.secondary_private_site_ip
          psk             = var.tunnel2_preshared_key
          last_mile_bw = {
            downstream = var.downstream_bw
            upstream   = var.upstream_bw
            # downstream_mbps_precision = 1
            # upstream_mbps_precision = 1
          }
        }
      ]
    }
  }
}

resource "cato_bgp_peer" "primary" {
  site_id                  = cato_ipsec_site.ipsec-site.id
  name                     = "Primary Peering"
  cato_asn                 = var.cato_bgp_asn
  peer_asn                 = var.aws_cgw_bgp_asn
  peer_ip                  = var.primary_private_site_ip
  metric                   = 100
  default_action           = "ACCEPT"
  advertise_all_routes     = true
  advertise_default_route  = false
  advertise_summary_routes = false

  bfd_settings = {
    transmit_interval = 1000
    receive_interval  = 1000
    multiplier        = 5
  }
}

resource "cato_bgp_peer" "backup" {
  site_id                  = cato_ipsec_site.ipsec-site.id
  name                     = "Secondary Peering"
  cato_asn                 = var.cato_bgp_asn
  peer_asn                 = var.aws_cgw_bgp_asn
  peer_ip                  = var.secondary_private_site_ip
  metric                   = 150
  default_action           = "ACCEPT"
  advertise_all_routes     = true
  advertise_default_route  = false
  advertise_summary_routes = false

  bfd_settings = {
    transmit_interval = 1000
    receive_interval  = 1000
    multiplier        = 5
  }
}