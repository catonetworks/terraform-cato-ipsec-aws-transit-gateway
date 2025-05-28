##AWS Variables## 
variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "aws_transit_gateway_id" {
  description = "AWS Transit Gateway ID"
  type        = string
}

variable "primary_vpn_tunnel1_inside_cidr" {
  description = "Primary VPN, Tunnel 1 Inside CIDR"
  type        = string
}

variable "secondary_vpn_tunnel1_inside_cidr" {
  description = "Primary VPN, Tunnel 2 Inside CIDR"
  type        = string

}

variable "primary_vpn_tunnel2_inside_cidr" {
  description = "Primary VPN, Tunnel 1 Inside CIDR"
  type        = string
  default     = null
}

variable "secondary_vpn_tunnel2_inside_cidr" {
  description = "Primary VPN, Tunnel 2 Inside CIDR"
  type        = string
  default     = null
}


variable "primary_vpn_tunnel1_preshared_key" {
  description = "Primary VPN, Tunnel 1 Preshared Key"
  type        = string
  sensitive   = true
}

variable "primary_vpn_tunnel2_preshared_key" {
  description = "Primary VPN,Tunnel 2 Preshared Key"
  type        = string
  sensitive   = true
}

variable "secondary_vpn_tunnel1_preshared_key" {
  description = "Secondary VPN, Tunnel 1 Preshared Key"
  type        = string
  sensitive   = true
}

variable "secondary_vpn_tunnel2_preshared_key" {
  description = "Secondary VPN, Tunnel 2 Preshared Key"
  type        = string
  sensitive   = true
}

##Cato Variables## 

variable "baseurl" {
  description = "Cato API base URL"
  type        = string
  default     = "https://api.catonetworks.com/api/v1/graphql2"
}

variable "token" {
  description = "Cato API token"
  type        = string
}

variable "account_id" {
  description = "Cato account ID"
}

variable "cato_bgp_asn" {
  description = "Cato BGP ASN"
  type        = string
}

variable "aws_cgw_bgp_asn" {
  description = "AWS Customer Gateway BGP ASN"
  type        = string
}

variable "cato_primary_gateway_ip_address" {
  description = <<EOF
  Primary Allocated IP for Cato to build the tunnel with.
  Corresponds to Customer Primary Gateway IP Address
  EOF
  default     = null
  type        = string
}

variable "cato_secondary_gateway_ip_address" {
  description = <<EOF
  Primary Allocated IP for Cato to build the tunnel with.
  Corresponds to Customer Primary Gateway IP Address
  EOF
  default     = null
  type        = string
}

variable "cato_primary_bgp_peer_name" {
  description = "Cato Primary BGP Peer Name"
  type        = string
  default     = null
}

variable "cato_secondary_bgp_peer_name" {
  description = "Cato Secondary BGP Peer Name"
  type        = string
  default     = null
}

variable "cato_primary_bgp_default_action" {
  description = "Cato Primary BGP Default Action"
  type        = string
  default     = "ACCEPT"
}

variable "cato_secondary_bgp_default_action" {
  description = "Cato Secondary BGP Default Action"
  type        = string
  default     = "ACCEPT"
}

variable "cato_primary_bgp_metric" {
  description = "Cato Primary BGP Metric"
  type        = number
  default     = 100
}

variable "cato_secondary_bgp_metric" {
  description = "Cato Secondary BGP Metric"
  type        = number
  default     = 150
}

variable "cato_primary_bgp_advertise_all" {
  description = "Cato Primary BGP Advertise All"
  type        = bool
  default     = true
}

variable "cato_secondary_bgp_advertise_all" {
  description = "Cato Secondary BGP Advertise All"
  type        = bool
  default     = true
}

variable "cato_primary_bgp_advertise_default_route" {
  description = "Cato Primary BGP Advertise Default Route"
  type        = bool
  default     = false
}

variable "cato_secondary_bgp_advertise_default_route" {
  description = "Cato Secondary BGP Advertise Default Route"
  type        = bool
  default     = false
}

variable "cato_primary_bgp_advertise_summary_route" {
  description = "Cato Primary BGP Advertise Summary Route"
  type        = bool
  default     = false
}

variable "cato_secondary_bgp_advertise_summary_route" {
  description = "Cato Secondary BGP Advertise Summary Route"
  type        = bool
  default     = false
}

variable "cato_primary_bgp_bfd_transmit_interval" {
  description = "Cato Primary BGP BFD Transmit Interval"
  type        = number
  default     = 1000
}

variable "cato_secondary_bgp_bfd_transmit_interval" {
  description = "Cato Secondary BGP BFD Transmit Interval"
  type        = number
  default     = 1000
}

variable "cato_primary_bgp_bfd_receive_interval" {
  description = "Cato Primary BGP BFD Receive Interval"
  type        = number
  default     = 1000
}

variable "cato_secondary_bgp_bfd_receive_interval" {
  description = "Cato Secondary BGP BFD Receive Interval"
  type        = number
  default     = 1000
}

variable "cato_primary_bgp_bfd_multiplier" {
  description = "Cato Primary BGP BFD Multiplier"
  type        = number
  default     = 5
}

variable "cato_secondary_bgp_bfd_multiplier" {
  description = "Cato Secondary BGP BFD Multiplier"
  type        = number
  default     = 5
}



##General Variables##
variable "tags" {
  description = "Map of Key-Value Tags"
  default     = null
  type        = map(any)
}

variable "site_name" {
  description = "Name of the IPSec site"
  type        = string
}

variable "site_description" {
  description = "Description of the IPSec site"
  type        = string
}

variable "native_network_range" {
  description = "Native network range for the IPSec site"
  type        = string
}

variable "site_type" {
  description = "The type of the site"
  type        = string
  default     = "CLOUD_DC"
  validation {
    condition     = contains(["DATACENTER", "BRANCH", "CLOUD_DC", "HEADQUARTERS"], var.site_type)
    error_message = "The site_type variable must be one of 'DATACENTER','BRANCH','CLOUD_DC','HEADQUARTERS'."
  }
}

variable "site_location" {
  type = object({
    city         = string
    country_code = string
    state_code   = string
    timezone     = string
  })
  default = {
    city         = "Belmont"
    country_code = "US"
    state_code   = "US-CA" ## Optional - for countries with states
    timezone     = "America/Los_Angeles"
  }
}

variable "primary_private_cato_ip" {
  description = "Private IP address of the Cato side for the primary tunnel"
  type        = string
}

variable "primary_private_site_ip" {
  description = "Private IP address of the site side for the primary tunnel"
  type        = string
}

variable "primary_destination_type" {
  description = "The destination type of the IPsec tunnel"
  type        = string
  default     = null
}

variable "primary_pop_location_id" {
  description = "Primary tunnel POP location ID"
  type        = string
  default     = null
}

variable "secondary_private_cato_ip" {
  description = "Private IP address of the Cato side for the secondary tunnel"
  type        = string
}

variable "secondary_private_site_ip" {
  description = "Private IP address of the site side for the secondary tunnel"
  type        = string
}

variable "secondary_destination_type" {
  description = "The destination type of the IPsec tunnel"
  type        = string
  default     = null
}

variable "secondary_pop_location_id" {
  description = "Secondary tunnel POP location ID"
  type        = string
  default     = null
}

variable "downstream_bw" {
  description = "Downstream bandwidth in Mbps"
  type        = number
}

variable "upstream_bw" {
  description = "Upstream bandwidth in Mbps"
  type        = number
}

### VPN Variables

variable "primary_vpn_tunnel1_dpd_timeout_action" {
  description = <<EOT
  For Primary VPN Tunnel 1
  (Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. 
  Specify restart to restart the IKE initiation. 
  Specify clear to end the IKE session. 
  Valid values are clear | none | restart. 
  EOT
  default     = "none"
}

variable "primary_vpn_tunnel2_dpd_timeout_action" {
  description = <<EOT
  For Primary VPN Tunnel 2:
  Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. 
  Specify restart to restart the IKE initiation. 
  Specify clear to end the IKE session. 
  Valid values are clear | none | restart. 
  EOT
  default     = "none"
}

variable "primary_vpn_tunnel1_ike_versions" {
  type        = list(string)
  description = <<EOT
  A List of versions of IKE to use.  The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 | ikev2.
  EOT
  default     = ["ikev2"]
}

variable "primary_vpn_tunnel2_ike_versions" {
  type        = list(string)
  description = <<EOT
  A List of versions of IKE to use.  The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 | ikev2.
  EOT
  default     = ["ikev2"]
}

variable "primary_vpn_tunnel1_phase1_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
   List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. 
   Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
   EOF
  default     = [15]
}
variable "primary_vpn_tunnel2_phase1_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
   List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. 
   Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
   EOF
  default     = [15]
}
variable "primary_vpn_tunnel1_phase2_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
  List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are 2 | 5 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
  EOF
  default     = [15]
}
variable "primary_vpn_tunnel2_phase2_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
  List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are 2 | 5 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
  EOF
  default     = [15]
}
variable "primary_vpn_tunnel1_phase1_lifetime_seconds" {
  type        = number
  description = <<EOF
   The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. 
   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2
   EOF
  default     = 19800
}
variable "primary_vpn_tunnel1_phase2_lifetime_seconds" {
  type        = number
  description = <<EOF
  The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. 
  Valid value is between 900 and 3600. Cato Default is 3600 for Ikev2.
  EOF
  default     = 3600
}
variable "primary_vpn_tunnel2_phase1_lifetime_seconds" {
  type        = number
  description = <<EOF
   The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. 
   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2
   EOF
  default     = 19800
}
variable "primary_vpn_tunnel2_phase2_lifetime_seconds" {
  type        = number
  description = <<EOF
  The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. 
  Valid value is between 900 and 3600.  Cato Default is 3600 for Ikev2.
  EOF
  default     = 3600
}
variable "primary_vpn_tunnel1_phase1_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations.
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "primary_vpn_tunnel2_phase1_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations.
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "primary_vpn_tunnel1_phase2_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "primary_vpn_tunnel2_phase2_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. 
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "primary_vpn_tunnel1_phase1_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}
variable "primary_vpn_tunnel2_phase1_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}

variable "primary_vpn_tunnel1_phase2_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}
variable "primary_vpn_tunnel2_phase2_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}


variable "secondary_vpn_tunnel1_dpd_timeout_action" {
  description = <<EOT
  For Secondary Cato VPN Tunnel 1
  (Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. 
  Specify restart to restart the IKE initiation. 
  Specify clear to end the IKE session. 
  Valid values are clear | none | restart. 
  EOT
  default     = "none"
}

variable "secondary_vpn_tunnel2_dpd_timeout_action" {
  description = <<EOT
  For Secondary Cato VPN Tunnel 2:
  Optional, Default clear) The action to take after DPD timeout occurs for the Second VPN tunnel. 
  Specify restart to restart the IKE initiation. 
  Specify clear to end the IKE session. 
  Valid values are clear | none | restart. 
  EOT
  default     = "none"
}

variable "secondary_vpn_tunnel1_ike_versions" {
  type        = list(string)
  description = <<EOT
  A List of versions of IKE to use.  The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 | ikev2.
  EOT
  default     = ["ikev2"]
}

variable "secondary_vpn_tunnel2_ike_versions" {
  type        = list(string)
  description = <<EOT
  A List of versions of IKE to use.  The IKE versions that are permitted for the second VPN tunnel. Valid values are ikev1 | ikev2.
  EOT
  default     = ["ikev2"]
}

variable "secondary_vpn_tunnel1_phase1_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
   List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. 
   Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
   EOF
  default     = [15]
}
variable "secondary_vpn_tunnel2_phase1_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
   List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 1 IKE negotiations. 
   Valid values are 2 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
   EOF
  default     = [15]
}
variable "secondary_vpn_tunnel1_phase2_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
  List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are 2 | 5 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
  EOF
  default     = [15]
}
variable "secondary_vpn_tunnel2_phase2_dh_group_numbers" {
  type        = list(number)
  description = <<EOF
  List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 2 IKE negotiations. 
  Valid values are 2 | 5 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24.
  EOF
  default     = [15]
}
variable "secondary_vpn_tunnel1_phase1_lifetime_seconds" {
  type        = number
  description = <<EOF
   The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. 
   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2
   EOF
  default     = 19800
}
variable "secondary_vpn_tunnel1_phase2_lifetime_seconds" {
  type        = number
  description = <<EOF
  The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. 
  Valid value is between 900 and 3600. Cato Default is 3600 for Ikev2.
  EOF
  default     = 3600
}
variable "secondary_vpn_tunnel2_phase1_lifetime_seconds" {
  type        = number
  description = <<EOF
   The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. 
   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2
   EOF
  default     = 19800
}
variable "secondary_vpn_tunnel2_phase2_lifetime_seconds" {
  type        = number
  description = <<EOF
  The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. 
  Valid value is between 900 and 3600.  Cato Default is 3600 for Ikev2.
  EOF
  default     = 3600
}
variable "secondary_vpn_tunnel1_phase1_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations.
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "secondary_vpn_tunnel2_phase1_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations.
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "secondary_vpn_tunnel1_phase2_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "secondary_vpn_tunnel2_phase2_encryption_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. 
  Valid values are AES128 | AES256 | AES128-GCM-16 | AES256-GCM-16.
  EOF
  default     = ["AES256-GCM-16"]
}
variable "secondary_vpn_tunnel1_phase1_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}
variable "secondary_vpn_tunnel2_phase1_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}

variable "secondary_vpn_tunnel1_phase2_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}
variable "secondary_vpn_tunnel2_phase2_integrity_algorithms" {
  type        = list(string)
  description = <<EOF
  List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. 
  Valid values are SHA1 | SHA2-256 | SHA2-384 | SHA2-512.
  EOF
  default     = ["SHA2-256"]
}