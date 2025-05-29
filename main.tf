## Create Customer Gateway
resource "aws_customer_gateway" "main" {
  bgp_asn     = var.cato_bgp_asn
  ip_address  = var.cato_primary_gateway_ip_address
  type        = "ipsec.1"
  device_name = "cato-networks-cloud-primary"

  tags = merge({
    Name = "${var.site_name}-primary-customer-gateway"
  }, var.tags)
}

resource "aws_customer_gateway" "backup" {
  bgp_asn     = var.cato_bgp_asn
  ip_address  = var.cato_secondary_gateway_ip_address
  type        = "ipsec.1"
  device_name = "cato-networks-cloud-secondary"

  tags = merge({
    Name = "${var.site_name}-secondary-customer-gateway"
  }, var.tags)
}


resource "aws_vpn_connection" "main" {
  customer_gateway_id                  = aws_customer_gateway.main.id
  transit_gateway_id                   = var.aws_transit_gateway_id
  type                                 = aws_customer_gateway.main.type
  tunnel1_inside_cidr                  = var.primary_vpn_tunnel1_inside_cidr
  tunnel2_inside_cidr                  = var.primary_vpn_tunnel2_inside_cidr
  tunnel1_preshared_key                = var.primary_vpn_tunnel1_preshared_key
  tunnel2_preshared_key                = var.primary_vpn_tunnel2_preshared_key
  tunnel1_dpd_timeout_action           = var.primary_vpn_tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_action           = var.primary_vpn_tunnel2_dpd_timeout_action
  tunnel1_ike_versions                 = var.primary_vpn_tunnel1_ike_versions
  tunnel2_ike_versions                 = var.primary_vpn_tunnel2_ike_versions
  tunnel1_phase1_dh_group_numbers      = var.primary_vpn_tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.primary_vpn_tunnel2_phase1_dh_group_numbers
  tunnel1_phase2_dh_group_numbers      = var.primary_vpn_tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.primary_vpn_tunnel2_phase2_dh_group_numbers
  tunnel1_phase1_lifetime_seconds      = var.primary_vpn_tunnel1_phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds      = var.primary_vpn_tunnel2_phase1_lifetime_seconds
  tunnel1_phase2_lifetime_seconds      = var.primary_vpn_tunnel1_phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds      = var.primary_vpn_tunnel2_phase2_lifetime_seconds
  tunnel1_phase1_encryption_algorithms = var.primary_vpn_tunnel1_phase1_encryption_algorithms
  tunnel1_phase2_encryption_algorithms = var.primary_vpn_tunnel1_phase2_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.primary_vpn_tunnel1_phase1_integrity_algorithms
  tunnel1_phase2_integrity_algorithms  = var.primary_vpn_tunnel1_phase2_integrity_algorithms
  tunnel2_phase1_encryption_algorithms = var.primary_vpn_tunnel2_phase1_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.primary_vpn_tunnel2_phase2_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.primary_vpn_tunnel2_phase1_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.primary_vpn_tunnel2_phase2_integrity_algorithms

  tags = merge({
    Name = "${var.site_name}-primary-vpn-connection"
  }, var.tags)
}

resource "aws_vpn_connection" "backup" {
  customer_gateway_id                  = aws_customer_gateway.backup.id
  transit_gateway_id                   = var.aws_transit_gateway_id
  type                                 = aws_customer_gateway.backup.type
  tunnel1_inside_cidr                  = var.secondary_vpn_tunnel1_inside_cidr
  tunnel2_inside_cidr                  = var.secondary_vpn_tunnel2_inside_cidr
  tunnel1_preshared_key                = var.secondary_vpn_tunnel1_preshared_key
  tunnel2_preshared_key                = var.secondary_vpn_tunnel2_preshared_key
  tunnel1_dpd_timeout_action           = var.secondary_vpn_tunnel1_dpd_timeout_action
  tunnel2_dpd_timeout_action           = var.secondary_vpn_tunnel2_dpd_timeout_action
  tunnel1_ike_versions                 = var.secondary_vpn_tunnel1_ike_versions
  tunnel2_ike_versions                 = var.secondary_vpn_tunnel2_ike_versions
  tunnel1_phase1_dh_group_numbers      = var.secondary_vpn_tunnel1_phase1_dh_group_numbers
  tunnel2_phase1_dh_group_numbers      = var.secondary_vpn_tunnel2_phase1_dh_group_numbers
  tunnel1_phase2_dh_group_numbers      = var.secondary_vpn_tunnel1_phase2_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = var.secondary_vpn_tunnel2_phase2_dh_group_numbers
  tunnel1_phase1_lifetime_seconds      = var.secondary_vpn_tunnel1_phase1_lifetime_seconds
  tunnel2_phase1_lifetime_seconds      = var.secondary_vpn_tunnel2_phase1_lifetime_seconds
  tunnel1_phase2_lifetime_seconds      = var.secondary_vpn_tunnel1_phase2_lifetime_seconds
  tunnel2_phase2_lifetime_seconds      = var.secondary_vpn_tunnel2_phase2_lifetime_seconds
  tunnel1_phase1_encryption_algorithms = var.secondary_vpn_tunnel1_phase1_encryption_algorithms
  tunnel1_phase2_encryption_algorithms = var.secondary_vpn_tunnel1_phase2_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.secondary_vpn_tunnel1_phase1_integrity_algorithms
  tunnel1_phase2_integrity_algorithms  = var.secondary_vpn_tunnel1_phase2_integrity_algorithms
  tunnel2_phase1_encryption_algorithms = var.secondary_vpn_tunnel2_phase1_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = var.secondary_vpn_tunnel2_phase2_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.secondary_vpn_tunnel2_phase1_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = var.secondary_vpn_tunnel2_phase2_integrity_algorithms


  tags = merge({
    Name = "${var.site_name}-secondary-vpn-connection"
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
      public_cato_ip_id = data.cato_allocatedIp.primary.items[0].id
      pop_location_id   = var.primary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.main.tunnel1_address
          private_cato_ip = var.primary_private_cato_ip
          private_site_ip = var.primary_private_site_ip
          psk             = var.primary_vpn_tunnel1_preshared_key
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
      public_cato_ip_id = data.cato_allocatedIp.secondary.items[0].id
      pop_location_id   = var.secondary_pop_location_id
      tunnels = [
        {
          public_site_ip  = aws_vpn_connection.backup.tunnel1_address
          private_cato_ip = var.secondary_private_cato_ip
          private_site_ip = var.secondary_private_site_ip
          psk             = var.secondary_vpn_tunnel1_preshared_key
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
  name                     = var.cato_primary_bgp_peer_name == null ? "${var.site_name}-primary-bgp-peer" : var.cato_primary_bgp_peer_name
  cato_asn                 = var.cato_bgp_asn
  peer_asn                 = data.aws_ec2_transit_gateway.this.amazon_side_asn
  peer_ip                  = var.primary_private_site_ip
  metric                   = var.cato_primary_bgp_metric
  default_action           = var.cato_primary_bgp_default_action
  advertise_all_routes     = var.cato_primary_bgp_advertise_all
  advertise_default_route  = var.cato_primary_bgp_advertise_default_route
  advertise_summary_routes = var.cato_primary_bgp_advertise_summary_route
  md5_auth_key             = "" #Inserting Blank Value to Avoid State Changes 

  bfd_settings = {
    transmit_interval = var.cato_primary_bgp_bfd_transmit_interval
    receive_interval  = var.cato_primary_bgp_bfd_receive_interval
    multiplier        = var.cato_primary_bgp_bfd_multiplier
  }
  # Inserting Ignore to avoid API and TF Fighting over a Null Value 
  lifecycle {
    ignore_changes = [
      summary_route
    ]
  }
}

resource "cato_bgp_peer" "backup" {
  site_id                  = cato_ipsec_site.ipsec-site.id
  name                     = var.cato_secondary_bgp_peer_name == null ? "${var.site_name}-secondary-bgp-peer" : var.cato_secondary_bgp_peer_name
  cato_asn                 = var.cato_bgp_asn
  peer_asn                 = data.aws_ec2_transit_gateway.this.amazon_side_asn
  peer_ip                  = var.secondary_private_site_ip
  metric                   = var.cato_secondary_bgp_metric
  default_action           = var.cato_secondary_bgp_default_action
  advertise_all_routes     = var.cato_secondary_bgp_advertise_all
  advertise_default_route  = var.cato_secondary_bgp_advertise_default_route
  advertise_summary_routes = var.cato_secondary_bgp_advertise_summary_route
  md5_auth_key             = "" #Inserting Blank Value to Avoid State Changes 

  bfd_settings = {
    transmit_interval = var.cato_secondary_bgp_bfd_transmit_interval
    receive_interval  = var.cato_secondary_bgp_bfd_receive_interval
    multiplier        = var.cato_secondary_bgp_bfd_multiplier
  }

  lifecycle {
    ignore_changes = [
      summary_route
    ]
  }
}