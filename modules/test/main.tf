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

//TODO:  Add Direct Ranges for the BGP Peers in the Site to Allow BGP to Come up
// Ref: conversation with Robert Goodall: 
// youll need to add in direct ranges covering the BGP subnets for the IPsec BGP to work
// Per Conversation with Rob Pfrogner Isn't needed. 


resource "cato_network_range" "bgp-primary" {
  site_id = cato_ipsec_site.ipsec-site.id
  name = "bgp-primary"
  range_type = "Direct"
  subnet = var.tunnel1_inside_cidr
  interface_id = "159023"
  local_ip = var.primary_private_cato_ip
}

resource "cato_network_range" "bgp-secondary" {
  site_id = cato_ipsec_site.ipsec-site.id
  name = "bgp-secondary"
  range_type = "Direct"
  subnet = var.tunnel2_inside_cidr
  interface_id = "159023"
  local_ip = var.secondary_private_cato_ip
}

// Doesn't work with IPSEC Sites? - Provider is trying to pass lan socket interface 
# 2025-05-05T13:47:56.716-0500 [DEBUG] provider.terraform-provider-cato: 2025/05/05 13:47:56 [DEBUG] POST https://api.catonetworks.com/api/v1/graphql2
# 2025-05-05T13:47:57.506-0500 [ERROR] provider.terraform-provider-cato: Response contains error diagnostic: @module=sdk.proto diagnostic_summary="Cato API SiteAddNetworkRange error" tf_proto_version=6.6 tf_provider_addr=registry.terraform.io/catonetworks/cato tf_req_id=51aadca1-85ba-e0fd-f513-577d094afe4f tf_rpc=ApplyResourceChange @caller=/Users/justinrichert/git/work/cato/terraform-provider-cato/vendor/github.com/hashicorp/terraform-plugin-go/tfprotov6/internal/diag/diagnostics.go:58 diagnostic_detail="{"networkErrors":null,"graphqlErrors":[{"message":"lan socket interface with id:  not found","path":["site","addNetworkRange"]}]}" diagnostic_severity=ERROR tf_resource_type=cato_network_range timestamp=2025-05-05T13:47:57.506-0500
# 2025-05-05T13:47:57.520-0500 [DEBUG] State storage *statemgr.Filesystem declined to persist a state snapshot
# 2025-05-05T13:47:57.520-0500 [ERROR] vertex "module.ipsec-aws-tgw.cato_network_range.bgp-primary" error: Cato API SiteAddNetworkRange error

## API Call wants Local IP, But GUI Doesn't: 
# curl -k -X POST -H "Accept: application/json" -H "Content-Type: application/json"  -H "x-API-Key: ********************************" 'https://api.catonetworks.com/api/v1/graphql2' --data '{"query":"mutation sitesAddNetworkRange ( $lanSocketInterfaceId:ID! $addNetworkRangeInput:AddNetworkRangeInput! $accountId:ID! ) { sites ( accountId:$accountId ) {   addNetworkRange ( lanSocketInterfaceId:$lanSocketInterfaceId  input:$addNetworkRangeInput  )  { networkRangeId   }   }  }","variables":{"accountId":"14881","addNetworkRangeInput":{"localIp":"169.254.100.2","name":"bgp-primary","rangeType":"Direct","subnet":"169.254.100.0/30"},"lanSocketInterfaceId":"159023"},"operationName":"sitesAddNetworkRange"}'
# GUI Doesn't ask for a LAN IP... WHY NOT?!?!?!!?! 
#



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



# resource "cato_bgp_peer" "primary" {
#   site_id                  = cato_ipsec_site.ipsec-site.id
#   name                     = "Primary Peering"
#   cato_asn                 = var.cato_bgp_asn
#   peer_asn                 = var.aws_cgw_bgp_asn
#   peer_ip                  = var.primary_private_site_ip
#   metric                   = 100
#   default_action           = "ACCEPT"
#   advertise_all_routes     = true
#   advertise_default_route  = false
#   advertise_summary_routes = false

#   bfd_settings = {
#     transmit_interval = 1000
#     receive_interval  = 1000
#     multiplier        = 5
#   }
# }

# resource "cato_bgp_peer" "backup" {
#   site_id                  = cato_ipsec_site.ipsec-site.id
#   name                     = "Secondary Peering"
#   cato_asn                 = var.cato_bgp_asn
#   peer_asn                 = var.aws_cgw_bgp_asn
#   peer_ip                  = var.secondary_private_site_ip
#   metric                   = 150
#   default_action           = "ACCEPT"
#   advertise_all_routes     = true
#   advertise_default_route  = false
#   advertise_summary_routes = false

#   bfd_settings = {
#     transmit_interval = 1000
#     receive_interval  = 1000
#     multiplier        = 5
#   }
# }