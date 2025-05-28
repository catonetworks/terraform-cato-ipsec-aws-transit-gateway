# Cato IPSEC Site AWS Transit Gateway Module 

Terraform module which creates a Cato IPSEC Site and connects it to a already created AWS Transit Gateway
Requires an aws transit gateway ID (tgw_id) to connect to., 

## NOTE
- For help with finding exact sytax to match site location for city, state_name, country_name and timezone, please refer to the [cato_siteLocation data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/siteLocation).
- For help with finding a license id to assign, please refer to the [cato_licensingInfo data source](https://registry.terraform.io/providers/catonetworks/cato/latest/docs/data-sources/licensingInfo).
- You will need to provide a primary and secondary allocated IP Address from the Cato Console for Cato to build the tunnels with. 


## Usage

```hcl
variable "token" {
  description = "Cato API Token - Use Env Var TF_VAR_token=<token>"
  type        = "string"
}

variable "account_id" {  
  description = "Cato Account ID - Use Env Var TF_VAR_account_id=<accountid>"
  type        = "string"
}

variable "baseurl" {
  description = "Cato API Base URL - Use Env Var TF_VAR_baseurl=<baseurl>"
  type        = "string"
}

variable "region" {
  description = "AWS Region to Use"
  default = "us-west-2"
}

provider "aws" {
  region = var.region
}

provider "cato" {
  account_id = var.account_id
  token      = var.token
  baseurl    = var.baseurl
}

module "ipsec-aws-tgw" {
  source                              = "catonetworks/ipsec-aws-tgw/cato"
  account_id                          = var.account_id
  token                               = var.token
  aws_transit_gateway_id              = "tgw-01234567890abcdef"
  region                              = var.region
  aws_cgw_bgp_asn                     = 64512 
  cato_bgp_asn                        = 65001
  cato_primary_gateway_ip_address     = "x.x.x.x"
  cato_secondary_gateway_ip_address   = "y.y.y.y"
  site_name                           = "AWS-Cato-IPSec-Site"
  site_description                    = "AWS Cato IPSec Site US-West-2"
  native_network_range                = "10.0.0.0/24"
  primary_vpn_tunnel1_inside_cidr     = "169.254.100.0/30"
  secondary_vpn_tunnel1_inside_cidr   = "169.254.200.0/30"
  primary_vpn_tunnel1_preshared_key   = "1234567890abcdefg"
  secondary_vpn_tunnel1_preshared_key = "1234567890abcdefg"
  primary_vpn_tunnel2_preshared_key   = "1234567890abcdefg"
  secondary_vpn_tunnel2_preshared_key = "1234567890abcdefg"
  
  #AWS Always takes the 1st IP in the Allocatied Subnet Range
  primary_private_cato_ip = "169.254.100.2"
  primary_private_site_ip = "169.254.100.1"
  
  #AWS Always takes the 1st IP in the Allocatied Subnet Range
  secondary_private_cato_ip = "169.254.200.2"
  secondary_private_site_ip = "169.254.200.1"
  
  downstream_bw             = 100
  upstream_bw               = 100
  site_location = {
    city         = "New York City"
    country_code = "US"
    state_code   = "US-NY" ## Optional - for countries with states"
    timezone     = "America/New_York"
  }
  
  tags = {
    built_with = "terraform"
    git_repo = "https://github.com/my/git.repo"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_cato"></a> [cato](#requirement\_cato) | 0.0.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_cato"></a> [cato](#provider\_cato) | 0.0.23 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_customer_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_vpn_connection.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [cato_bgp_peer.backup](https://registry.terraform.io/providers/terraform-providers/cato/0.0.23/docs/resources/bgp_peer) | resource |
| [cato_bgp_peer.primary](https://registry.terraform.io/providers/terraform-providers/cato/0.0.23/docs/resources/bgp_peer) | resource |
| [cato_ipsec_site.ipsec-site](https://registry.terraform.io/providers/terraform-providers/cato/0.0.23/docs/resources/ipsec_site) | resource |
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_transit_gateway) | data source |
| [cato_allocatedIp.primary](https://registry.terraform.io/providers/terraform-providers/cato/0.0.23/docs/data-sources/allocatedIp) | data source |
| [cato_allocatedIp.secondary](https://registry.terraform.io/providers/terraform-providers/cato/0.0.23/docs/data-sources/allocatedIp) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Cato account ID | `any` | n/a | yes |
| <a name="input_aws_cgw_bgp_asn"></a> [aws\_cgw\_bgp\_asn](#input\_aws\_cgw\_bgp\_asn) | AWS Customer Gateway BGP ASN | `string` | n/a | yes |
| <a name="input_aws_transit_gateway_id"></a> [aws\_transit\_gateway\_id](#input\_aws\_transit\_gateway\_id) | AWS Transit Gateway ID | `string` | n/a | yes |
| <a name="input_baseurl"></a> [baseurl](#input\_baseurl) | Cato API base URL | `string` | `"https://api.catonetworks.com/api/v1/graphql2"` | no |
| <a name="input_cato_bgp_asn"></a> [cato\_bgp\_asn](#input\_cato\_bgp\_asn) | Cato BGP ASN | `string` | n/a | yes |
| <a name="input_cato_primary_bgp_advertise_all"></a> [cato\_primary\_bgp\_advertise\_all](#input\_cato\_primary\_bgp\_advertise\_all) | Cato Primary BGP Advertise All | `bool` | `true` | no |
| <a name="input_cato_primary_bgp_advertise_default_route"></a> [cato\_primary\_bgp\_advertise\_default\_route](#input\_cato\_primary\_bgp\_advertise\_default\_route) | Cato Primary BGP Advertise Default Route | `bool` | `false` | no |
| <a name="input_cato_primary_bgp_advertise_summary_route"></a> [cato\_primary\_bgp\_advertise\_summary\_route](#input\_cato\_primary\_bgp\_advertise\_summary\_route) | Cato Primary BGP Advertise Summary Route | `bool` | `false` | no |
| <a name="input_cato_primary_bgp_bfd_multiplier"></a> [cato\_primary\_bgp\_bfd\_multiplier](#input\_cato\_primary\_bgp\_bfd\_multiplier) | Cato Primary BGP BFD Multiplier | `number` | `5` | no |
| <a name="input_cato_primary_bgp_bfd_receive_interval"></a> [cato\_primary\_bgp\_bfd\_receive\_interval](#input\_cato\_primary\_bgp\_bfd\_receive\_interval) | Cato Primary BGP BFD Receive Interval | `number` | `1000` | no |
| <a name="input_cato_primary_bgp_bfd_transmit_interval"></a> [cato\_primary\_bgp\_bfd\_transmit\_interval](#input\_cato\_primary\_bgp\_bfd\_transmit\_interval) | Cato Primary BGP BFD Transmit Interval | `number` | `1000` | no |
| <a name="input_cato_primary_bgp_default_action"></a> [cato\_primary\_bgp\_default\_action](#input\_cato\_primary\_bgp\_default\_action) | Cato Primary BGP Default Action | `string` | `"ACCEPT"` | no |
| <a name="input_cato_primary_bgp_metric"></a> [cato\_primary\_bgp\_metric](#input\_cato\_primary\_bgp\_metric) | Cato Primary BGP Metric | `number` | `100` | no |
| <a name="input_cato_primary_bgp_peer_name"></a> [cato\_primary\_bgp\_peer\_name](#input\_cato\_primary\_bgp\_peer\_name) | Cato Primary BGP Peer Name | `string` | `null` | no |
| <a name="input_cato_primary_gateway_ip_address"></a> [cato\_primary\_gateway\_ip\_address](#input\_cato\_primary\_gateway\_ip\_address) | Primary Allocated IP for Cato to build the tunnel with.<br/>  Corresponds to Customer Primary Gateway IP Address | `string` | `null` | no |
| <a name="input_cato_secondary_bgp_advertise_all"></a> [cato\_secondary\_bgp\_advertise\_all](#input\_cato\_secondary\_bgp\_advertise\_all) | Cato Secondary BGP Advertise All | `bool` | `true` | no |
| <a name="input_cato_secondary_bgp_advertise_default_route"></a> [cato\_secondary\_bgp\_advertise\_default\_route](#input\_cato\_secondary\_bgp\_advertise\_default\_route) | Cato Secondary BGP Advertise Default Route | `bool` | `false` | no |
| <a name="input_cato_secondary_bgp_advertise_summary_route"></a> [cato\_secondary\_bgp\_advertise\_summary\_route](#input\_cato\_secondary\_bgp\_advertise\_summary\_route) | Cato Secondary BGP Advertise Summary Route | `bool` | `false` | no |
| <a name="input_cato_secondary_bgp_bfd_multiplier"></a> [cato\_secondary\_bgp\_bfd\_multiplier](#input\_cato\_secondary\_bgp\_bfd\_multiplier) | Cato Secondary BGP BFD Multiplier | `number` | `5` | no |
| <a name="input_cato_secondary_bgp_bfd_receive_interval"></a> [cato\_secondary\_bgp\_bfd\_receive\_interval](#input\_cato\_secondary\_bgp\_bfd\_receive\_interval) | Cato Secondary BGP BFD Receive Interval | `number` | `1000` | no |
| <a name="input_cato_secondary_bgp_bfd_transmit_interval"></a> [cato\_secondary\_bgp\_bfd\_transmit\_interval](#input\_cato\_secondary\_bgp\_bfd\_transmit\_interval) | Cato Secondary BGP BFD Transmit Interval | `number` | `1000` | no |
| <a name="input_cato_secondary_bgp_default_action"></a> [cato\_secondary\_bgp\_default\_action](#input\_cato\_secondary\_bgp\_default\_action) | Cato Secondary BGP Default Action | `string` | `"ACCEPT"` | no |
| <a name="input_cato_secondary_bgp_metric"></a> [cato\_secondary\_bgp\_metric](#input\_cato\_secondary\_bgp\_metric) | Cato Secondary BGP Metric | `number` | `150` | no |
| <a name="input_cato_secondary_bgp_peer_name"></a> [cato\_secondary\_bgp\_peer\_name](#input\_cato\_secondary\_bgp\_peer\_name) | Cato Secondary BGP Peer Name | `string` | `null` | no |
| <a name="input_cato_secondary_gateway_ip_address"></a> [cato\_secondary\_gateway\_ip\_address](#input\_cato\_secondary\_gateway\_ip\_address) | Primary Allocated IP for Cato to build the tunnel with.<br/>  Corresponds to Customer Primary Gateway IP Address | `string` | `null` | no |
| <a name="input_downstream_bw"></a> [downstream\_bw](#input\_downstream\_bw) | Downstream bandwidth in Mbps | `number` | n/a | yes |
| <a name="input_native_network_range"></a> [native\_network\_range](#input\_native\_network\_range) | Native network range for the IPSec site | `string` | n/a | yes |
| <a name="input_primary_destination_type"></a> [primary\_destination\_type](#input\_primary\_destination\_type) | The destination type of the IPsec tunnel | `string` | `null` | no |
| <a name="input_primary_pop_location_id"></a> [primary\_pop\_location\_id](#input\_primary\_pop\_location\_id) | Primary tunnel POP location ID | `string` | `null` | no |
| <a name="input_primary_private_cato_ip"></a> [primary\_private\_cato\_ip](#input\_primary\_private\_cato\_ip) | Private IP address of the Cato side for the primary tunnel | `string` | n/a | yes |
| <a name="input_primary_private_site_ip"></a> [primary\_private\_site\_ip](#input\_primary\_private\_site\_ip) | Private IP address of the site side for the primary tunnel | `string` | n/a | yes |
| <a name="input_primary_vpn_tunnel1_dpd_timeout_action"></a> [primary\_vpn\_tunnel1\_dpd\_timeout\_action](#input\_primary\_vpn\_tunnel1\_dpd\_timeout\_action) | For Primary VPN Tunnel 1<br/>  (Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. <br/>  Specify restart to restart the IKE initiation. <br/>  Specify clear to end the IKE session. <br/>  Valid values are clear \| none \| restart. | `string` | `"none"` | no |
| <a name="input_primary_vpn_tunnel1_ike_versions"></a> [primary\_vpn\_tunnel1\_ike\_versions](#input\_primary\_vpn\_tunnel1\_ike\_versions) | A List of versions of IKE to use.  The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 \| ikev2. | `list(string)` | <pre>[<br/>  "ikev2"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_inside_cidr"></a> [primary\_vpn\_tunnel1\_inside\_cidr](#input\_primary\_vpn\_tunnel1\_inside\_cidr) | Primary VPN, Tunnel 1 Inside CIDR | `string` | n/a | yes |
| <a name="input_primary_vpn_tunnel1_phase1_dh_group_numbers"></a> [primary\_vpn\_tunnel1\_phase1\_dh\_group\_numbers](#input\_primary\_vpn\_tunnel1\_phase1\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. <br/>   Valid values are 2 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_phase1_encryption_algorithms"></a> [primary\_vpn\_tunnel1\_phase1\_encryption\_algorithms](#input\_primary\_vpn\_tunnel1\_phase1\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations.<br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_phase1_integrity_algorithms"></a> [primary\_vpn\_tunnel1\_phase1\_integrity\_algorithms](#input\_primary\_vpn\_tunnel1\_phase1\_integrity\_algorithms) | One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_phase1_lifetime_seconds"></a> [primary\_vpn\_tunnel1\_phase1\_lifetime\_seconds](#input\_primary\_vpn\_tunnel1\_phase1\_lifetime\_seconds) | The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. <br/>   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2 | `number` | `19800` | no |
| <a name="input_primary_vpn_tunnel1_phase2_dh_group_numbers"></a> [primary\_vpn\_tunnel1\_phase2\_dh\_group\_numbers](#input\_primary\_vpn\_tunnel1\_phase2\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are 2 \| 5 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_phase2_encryption_algorithms"></a> [primary\_vpn\_tunnel1\_phase2\_encryption\_algorithms](#input\_primary\_vpn\_tunnel1\_phase2\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_phase2_integrity_algorithms"></a> [primary\_vpn\_tunnel1\_phase2\_integrity\_algorithms](#input\_primary\_vpn\_tunnel1\_phase2\_integrity\_algorithms) | List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel1_phase2_lifetime_seconds"></a> [primary\_vpn\_tunnel1\_phase2\_lifetime\_seconds](#input\_primary\_vpn\_tunnel1\_phase2\_lifetime\_seconds) | The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. <br/>  Valid value is between 900 and 3600. Cato Default is 3600 for Ikev2. | `number` | `3600` | no |
| <a name="input_primary_vpn_tunnel1_preshared_key"></a> [primary\_vpn\_tunnel1\_preshared\_key](#input\_primary\_vpn\_tunnel1\_preshared\_key) | Primary VPN, Tunnel 1 Preshared Key | `string` | n/a | yes |
| <a name="input_primary_vpn_tunnel2_dpd_timeout_action"></a> [primary\_vpn\_tunnel2\_dpd\_timeout\_action](#input\_primary\_vpn\_tunnel2\_dpd\_timeout\_action) | For Primary VPN Tunnel 2:<br/>  Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. <br/>  Specify restart to restart the IKE initiation. <br/>  Specify clear to end the IKE session. <br/>  Valid values are clear \| none \| restart. | `string` | `"none"` | no |
| <a name="input_primary_vpn_tunnel2_ike_versions"></a> [primary\_vpn\_tunnel2\_ike\_versions](#input\_primary\_vpn\_tunnel2\_ike\_versions) | A List of versions of IKE to use.  The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 \| ikev2. | `list(string)` | <pre>[<br/>  "ikev2"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_inside_cidr"></a> [primary\_vpn\_tunnel2\_inside\_cidr](#input\_primary\_vpn\_tunnel2\_inside\_cidr) | Primary VPN, Tunnel 1 Inside CIDR | `string` | `null` | no |
| <a name="input_primary_vpn_tunnel2_phase1_dh_group_numbers"></a> [primary\_vpn\_tunnel2\_phase1\_dh\_group\_numbers](#input\_primary\_vpn\_tunnel2\_phase1\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. <br/>   Valid values are 2 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_phase1_encryption_algorithms"></a> [primary\_vpn\_tunnel2\_phase1\_encryption\_algorithms](#input\_primary\_vpn\_tunnel2\_phase1\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations.<br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_phase1_integrity_algorithms"></a> [primary\_vpn\_tunnel2\_phase1\_integrity\_algorithms](#input\_primary\_vpn\_tunnel2\_phase1\_integrity\_algorithms) | One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_phase1_lifetime_seconds"></a> [primary\_vpn\_tunnel2\_phase1\_lifetime\_seconds](#input\_primary\_vpn\_tunnel2\_phase1\_lifetime\_seconds) | The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. <br/>   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2 | `number` | `19800` | no |
| <a name="input_primary_vpn_tunnel2_phase2_dh_group_numbers"></a> [primary\_vpn\_tunnel2\_phase2\_dh\_group\_numbers](#input\_primary\_vpn\_tunnel2\_phase2\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are 2 \| 5 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_phase2_encryption_algorithms"></a> [primary\_vpn\_tunnel2\_phase2\_encryption\_algorithms](#input\_primary\_vpn\_tunnel2\_phase2\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_phase2_integrity_algorithms"></a> [primary\_vpn\_tunnel2\_phase2\_integrity\_algorithms](#input\_primary\_vpn\_tunnel2\_phase2\_integrity\_algorithms) | List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_primary_vpn_tunnel2_phase2_lifetime_seconds"></a> [primary\_vpn\_tunnel2\_phase2\_lifetime\_seconds](#input\_primary\_vpn\_tunnel2\_phase2\_lifetime\_seconds) | The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. <br/>  Valid value is between 900 and 3600.  Cato Default is 3600 for Ikev2. | `number` | `3600` | no |
| <a name="input_primary_vpn_tunnel2_preshared_key"></a> [primary\_vpn\_tunnel2\_preshared\_key](#input\_primary\_vpn\_tunnel2\_preshared\_key) | Primary VPN,Tunnel 2 Preshared Key | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_secondary_destination_type"></a> [secondary\_destination\_type](#input\_secondary\_destination\_type) | The destination type of the IPsec tunnel | `string` | `null` | no |
| <a name="input_secondary_pop_location_id"></a> [secondary\_pop\_location\_id](#input\_secondary\_pop\_location\_id) | Secondary tunnel POP location ID | `string` | `null` | no |
| <a name="input_secondary_private_cato_ip"></a> [secondary\_private\_cato\_ip](#input\_secondary\_private\_cato\_ip) | Private IP address of the Cato side for the secondary tunnel | `string` | n/a | yes |
| <a name="input_secondary_private_site_ip"></a> [secondary\_private\_site\_ip](#input\_secondary\_private\_site\_ip) | Private IP address of the site side for the secondary tunnel | `string` | n/a | yes |
| <a name="input_secondary_vpn_tunnel1_dpd_timeout_action"></a> [secondary\_vpn\_tunnel1\_dpd\_timeout\_action](#input\_secondary\_vpn\_tunnel1\_dpd\_timeout\_action) | For Secondary Cato VPN Tunnel 1<br/>  (Optional, Default clear) The action to take after DPD timeout occurs for the first VPN tunnel. <br/>  Specify restart to restart the IKE initiation. <br/>  Specify clear to end the IKE session. <br/>  Valid values are clear \| none \| restart. | `string` | `"none"` | no |
| <a name="input_secondary_vpn_tunnel1_ike_versions"></a> [secondary\_vpn\_tunnel1\_ike\_versions](#input\_secondary\_vpn\_tunnel1\_ike\_versions) | A List of versions of IKE to use.  The IKE versions that are permitted for the first VPN tunnel. Valid values are ikev1 \| ikev2. | `list(string)` | <pre>[<br/>  "ikev2"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_inside_cidr"></a> [secondary\_vpn\_tunnel1\_inside\_cidr](#input\_secondary\_vpn\_tunnel1\_inside\_cidr) | Primary VPN, Tunnel 2 Inside CIDR | `string` | n/a | yes |
| <a name="input_secondary_vpn_tunnel1_phase1_dh_group_numbers"></a> [secondary\_vpn\_tunnel1\_phase1\_dh\_group\_numbers](#input\_secondary\_vpn\_tunnel1\_phase1\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 1 IKE negotiations. <br/>   Valid values are 2 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_phase1_encryption_algorithms"></a> [secondary\_vpn\_tunnel1\_phase1\_encryption\_algorithms](#input\_secondary\_vpn\_tunnel1\_phase1\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations.<br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_phase1_integrity_algorithms"></a> [secondary\_vpn\_tunnel1\_phase1\_integrity\_algorithms](#input\_secondary\_vpn\_tunnel1\_phase1\_integrity\_algorithms) | One or more integrity algorithms that are permitted for the first VPN tunnel for phase 1 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_phase1_lifetime_seconds"></a> [secondary\_vpn\_tunnel1\_phase1\_lifetime\_seconds](#input\_secondary\_vpn\_tunnel1\_phase1\_lifetime\_seconds) | The lifetime for phase 1 of the IKE negotiation for the first VPN tunnel, in seconds. <br/>   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2 | `number` | `19800` | no |
| <a name="input_secondary_vpn_tunnel1_phase2_dh_group_numbers"></a> [secondary\_vpn\_tunnel1\_phase2\_dh\_group\_numbers](#input\_secondary\_vpn\_tunnel1\_phase2\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are 2 \| 5 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_phase2_encryption_algorithms"></a> [secondary\_vpn\_tunnel1\_phase2\_encryption\_algorithms](#input\_secondary\_vpn\_tunnel1\_phase2\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_phase2_integrity_algorithms"></a> [secondary\_vpn\_tunnel1\_phase2\_integrity\_algorithms](#input\_secondary\_vpn\_tunnel1\_phase2\_integrity\_algorithms) | List of one or more integrity algorithms that are permitted for the first VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel1_phase2_lifetime_seconds"></a> [secondary\_vpn\_tunnel1\_phase2\_lifetime\_seconds](#input\_secondary\_vpn\_tunnel1\_phase2\_lifetime\_seconds) | The lifetime for phase 2 of the IKE negotiation for the first VPN tunnel, in seconds. <br/>  Valid value is between 900 and 3600. Cato Default is 3600 for Ikev2. | `number` | `3600` | no |
| <a name="input_secondary_vpn_tunnel1_preshared_key"></a> [secondary\_vpn\_tunnel1\_preshared\_key](#input\_secondary\_vpn\_tunnel1\_preshared\_key) | Secondary VPN, Tunnel 1 Preshared Key | `string` | n/a | yes |
| <a name="input_secondary_vpn_tunnel2_dpd_timeout_action"></a> [secondary\_vpn\_tunnel2\_dpd\_timeout\_action](#input\_secondary\_vpn\_tunnel2\_dpd\_timeout\_action) | For Secondary Cato VPN Tunnel 2:<br/>  Optional, Default clear) The action to take after DPD timeout occurs for the Second VPN tunnel. <br/>  Specify restart to restart the IKE initiation. <br/>  Specify clear to end the IKE session. <br/>  Valid values are clear \| none \| restart. | `string` | `"none"` | no |
| <a name="input_secondary_vpn_tunnel2_ike_versions"></a> [secondary\_vpn\_tunnel2\_ike\_versions](#input\_secondary\_vpn\_tunnel2\_ike\_versions) | A List of versions of IKE to use.  The IKE versions that are permitted for the second VPN tunnel. Valid values are ikev1 \| ikev2. | `list(string)` | <pre>[<br/>  "ikev2"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_inside_cidr"></a> [secondary\_vpn\_tunnel2\_inside\_cidr](#input\_secondary\_vpn\_tunnel2\_inside\_cidr) | Primary VPN, Tunnel 2 Inside CIDR | `string` | `null` | no |
| <a name="input_secondary_vpn_tunnel2_phase1_dh_group_numbers"></a> [secondary\_vpn\_tunnel2\_phase1\_dh\_group\_numbers](#input\_secondary\_vpn\_tunnel2\_phase1\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 1 IKE negotiations. <br/>   Valid values are 2 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_phase1_encryption_algorithms"></a> [secondary\_vpn\_tunnel2\_phase1\_encryption\_algorithms](#input\_secondary\_vpn\_tunnel2\_phase1\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations.<br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_phase1_integrity_algorithms"></a> [secondary\_vpn\_tunnel2\_phase1\_integrity\_algorithms](#input\_secondary\_vpn\_tunnel2\_phase1\_integrity\_algorithms) | One or more integrity algorithms that are permitted for the second VPN tunnel for phase 1 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_phase1_lifetime_seconds"></a> [secondary\_vpn\_tunnel2\_phase1\_lifetime\_seconds](#input\_secondary\_vpn\_tunnel2\_phase1\_lifetime\_seconds) | The lifetime for phase 1 of the IKE negotiation for the second VPN tunnel, in seconds. <br/>   Valid value is between 900 and 28800. Cato Default is 19800 for Ikev2 | `number` | `19800` | no |
| <a name="input_secondary_vpn_tunnel2_phase2_dh_group_numbers"></a> [secondary\_vpn\_tunnel2\_phase2\_dh\_group\_numbers](#input\_secondary\_vpn\_tunnel2\_phase2\_dh\_group\_numbers) | List of one or more Diffie-Hellman group numbers that are permitted for the second VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are 2 \| 5 \| 14 \| 15 \| 16 \| 17 \| 18 \| 19 \| 20 \| 21 \| 22 \| 23 \| 24. | `list(number)` | <pre>[<br/>  15<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_phase2_encryption_algorithms"></a> [secondary\_vpn\_tunnel2\_phase2\_encryption\_algorithms](#input\_secondary\_vpn\_tunnel2\_phase2\_encryption\_algorithms) | List of one or more encryption algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are AES128 \| AES256 \| AES128-GCM-16 \| AES256-GCM-16. | `list(string)` | <pre>[<br/>  "AES256-GCM-16"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_phase2_integrity_algorithms"></a> [secondary\_vpn\_tunnel2\_phase2\_integrity\_algorithms](#input\_secondary\_vpn\_tunnel2\_phase2\_integrity\_algorithms) | List of one or more integrity algorithms that are permitted for the second VPN tunnel for phase 2 IKE negotiations. <br/>  Valid values are SHA1 \| SHA2-256 \| SHA2-384 \| SHA2-512. | `list(string)` | <pre>[<br/>  "SHA2-256"<br/>]</pre> | no |
| <a name="input_secondary_vpn_tunnel2_phase2_lifetime_seconds"></a> [secondary\_vpn\_tunnel2\_phase2\_lifetime\_seconds](#input\_secondary\_vpn\_tunnel2\_phase2\_lifetime\_seconds) | The lifetime for phase 2 of the IKE negotiation for the second VPN tunnel, in seconds. <br/>  Valid value is between 900 and 3600.  Cato Default is 3600 for Ikev2. | `number` | `3600` | no |
| <a name="input_secondary_vpn_tunnel2_preshared_key"></a> [secondary\_vpn\_tunnel2\_preshared\_key](#input\_secondary\_vpn\_tunnel2\_preshared\_key) | Secondary VPN, Tunnel 2 Preshared Key | `string` | n/a | yes |
| <a name="input_site_description"></a> [site\_description](#input\_site\_description) | Description of the IPSec site | `string` | n/a | yes |
| <a name="input_site_location"></a> [site\_location](#input\_site\_location) | n/a | <pre>object({<br/>    city         = string<br/>    country_code = string<br/>    state_code   = string<br/>    timezone     = string<br/>  })</pre> | <pre>{<br/>  "city": "Belmont",<br/>  "country_code": "US",<br/>  "state_code": "US-CA",<br/>  "timezone": "America/Los_Angeles"<br/>}</pre> | no |
| <a name="input_site_name"></a> [site\_name](#input\_site\_name) | Name of the IPSec site | `string` | n/a | yes |
| <a name="input_site_type"></a> [site\_type](#input\_site\_type) | The type of the site | `string` | `"CLOUD_DC"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of Key-Value Tags | `map(any)` | `null` | no |
| <a name="input_token"></a> [token](#input\_token) | Cato API token | `string` | n/a | yes |
| <a name="input_upstream_bw"></a> [upstream\_bw](#input\_upstream\_bw) | Upstream bandwidth in Mbps | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_customer_gateway_backup_arn"></a> [aws\_customer\_gateway\_backup\_arn](#output\_aws\_customer\_gateway\_backup\_arn) | The ARN of the backup customer gateway |
| <a name="output_aws_customer_gateway_backup_id"></a> [aws\_customer\_gateway\_backup\_id](#output\_aws\_customer\_gateway\_backup\_id) | The amazon-assigned ID of the backup customer gateway |
| <a name="output_aws_customer_gateway_main_arn"></a> [aws\_customer\_gateway\_main\_arn](#output\_aws\_customer\_gateway\_main\_arn) | The ARN of the main customer gateway |
| <a name="output_aws_customer_gateway_main_id"></a> [aws\_customer\_gateway\_main\_id](#output\_aws\_customer\_gateway\_main\_id) | The amazon-assigned ID of the main customer gateway |
| <a name="output_aws_vpn_connection_backup_arn"></a> [aws\_vpn\_connection\_backup\_arn](#output\_aws\_vpn\_connection\_backup\_arn) | The ARN of the backup VPN connection |
| <a name="output_aws_vpn_connection_backup_customer_gateway_id"></a> [aws\_vpn\_connection\_backup\_customer\_gateway\_id](#output\_aws\_vpn\_connection\_backup\_customer\_gateway\_id) | The ID of the customer gateway to which the backup VPN connection is attached. |
| <a name="output_aws_vpn_connection_backup_id"></a> [aws\_vpn\_connection\_backup\_id](#output\_aws\_vpn\_connection\_backup\_id) | The amazon-assigned ID of the backup VPN connection |
| <a name="output_aws_vpn_connection_backup_transit_gateway_attachment_id"></a> [aws\_vpn\_connection\_backup\_transit\_gateway\_attachment\_id](#output\_aws\_vpn\_connection\_backup\_transit\_gateway\_attachment\_id) | When associated with an EC2 Transit Gateway (transit\_gateway\_id argument), the attachment ID. |
| <a name="output_aws_vpn_connection_backup_tunnel1_address"></a> [aws\_vpn\_connection\_backup\_tunnel1\_address](#output\_aws\_vpn\_connection\_backup\_tunnel1\_address) | For the backup VPN, The public IP address of the first tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel1_bgp_asn"></a> [aws\_vpn\_connection\_backup\_tunnel1\_bgp\_asn](#output\_aws\_vpn\_connection\_backup\_tunnel1\_bgp\_asn) | For the backup VPN, The bgp asn number of the first VPN tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel1_bgp_holdtime"></a> [aws\_vpn\_connection\_backup\_tunnel1\_bgp\_holdtime](#output\_aws\_vpn\_connection\_backup\_tunnel1\_bgp\_holdtime) | For the backup VPN, The bgp holdtime of the first VPN tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel1_cgw_inside_address"></a> [aws\_vpn\_connection\_backup\_tunnel1\_cgw\_inside\_address](#output\_aws\_vpn\_connection\_backup\_tunnel1\_cgw\_inside\_address) | For the backup VPN, The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side). |
| <a name="output_aws_vpn_connection_backup_tunnel1_preshared_key"></a> [aws\_vpn\_connection\_backup\_tunnel1\_preshared\_key](#output\_aws\_vpn\_connection\_backup\_tunnel1\_preshared\_key) | For the backup VPN, The preshared key of the first VPN tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel1_vgw_inside_address"></a> [aws\_vpn\_connection\_backup\_tunnel1\_vgw\_inside\_address](#output\_aws\_vpn\_connection\_backup\_tunnel1\_vgw\_inside\_address) | For the backup VPN, The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side). |
| <a name="output_aws_vpn_connection_backup_tunnel2_address"></a> [aws\_vpn\_connection\_backup\_tunnel2\_address](#output\_aws\_vpn\_connection\_backup\_tunnel2\_address) | For the backup VPN, The public IP address of the second tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel2_bgp_asn"></a> [aws\_vpn\_connection\_backup\_tunnel2\_bgp\_asn](#output\_aws\_vpn\_connection\_backup\_tunnel2\_bgp\_asn) | For the backup VPN, The bgp asn number of the second VPN tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel2_bgp_holdtime"></a> [aws\_vpn\_connection\_backup\_tunnel2\_bgp\_holdtime](#output\_aws\_vpn\_connection\_backup\_tunnel2\_bgp\_holdtime) | For the backup VPN, The bgp holdtime of the second VPN tunnel. |
| <a name="output_aws_vpn_connection_backup_tunnel2_cgw_inside_address"></a> [aws\_vpn\_connection\_backup\_tunnel2\_cgw\_inside\_address](#output\_aws\_vpn\_connection\_backup\_tunnel2\_cgw\_inside\_address) | For the backup VPN, The RFC 6890 link-local address of the second VPN tunnel. (Customer Gateway Side). |
| <a name="output_aws_vpn_connection_backup_tunnel2_preshared_key"></a> [aws\_vpn\_connection\_backup\_tunnel2\_preshared\_key](#output\_aws\_vpn\_connection\_backup\_tunnel2\_preshared\_key) | For the backup VPN, The preshared key of the second VPN tunnel. |
| <a name="output_aws_vpn_connection_main_arn"></a> [aws\_vpn\_connection\_main\_arn](#output\_aws\_vpn\_connection\_main\_arn) | The ARN of the main VPN connection |
| <a name="output_aws_vpn_connection_main_customer_gateway_id"></a> [aws\_vpn\_connection\_main\_customer\_gateway\_id](#output\_aws\_vpn\_connection\_main\_customer\_gateway\_id) | The ID of the customer gateway to which the main VPN connection is attached. |
| <a name="output_aws_vpn_connection_main_id"></a> [aws\_vpn\_connection\_main\_id](#output\_aws\_vpn\_connection\_main\_id) | The amazon-assigned ID of the main VPN connection |
| <a name="output_aws_vpn_connection_main_transit_gateway_attachment_id"></a> [aws\_vpn\_connection\_main\_transit\_gateway\_attachment\_id](#output\_aws\_vpn\_connection\_main\_transit\_gateway\_attachment\_id) | When associated with an EC2 Transit Gateway (transit\_gateway\_id argument), the attachment ID. |
| <a name="output_aws_vpn_connection_main_tunnel1_address"></a> [aws\_vpn\_connection\_main\_tunnel1\_address](#output\_aws\_vpn\_connection\_main\_tunnel1\_address) | For the Main VPN, The public IP address of the first tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel1_bgp_asn"></a> [aws\_vpn\_connection\_main\_tunnel1\_bgp\_asn](#output\_aws\_vpn\_connection\_main\_tunnel1\_bgp\_asn) | For the Main VPN, The bgp asn number of the first VPN tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel1_bgp_holdtime"></a> [aws\_vpn\_connection\_main\_tunnel1\_bgp\_holdtime](#output\_aws\_vpn\_connection\_main\_tunnel1\_bgp\_holdtime) | For the Main VPN, The bgp holdtime of the first VPN tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel1_cgw_inside_address"></a> [aws\_vpn\_connection\_main\_tunnel1\_cgw\_inside\_address](#output\_aws\_vpn\_connection\_main\_tunnel1\_cgw\_inside\_address) | For the Main VPN, The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side). |
| <a name="output_aws_vpn_connection_main_tunnel1_preshared_key"></a> [aws\_vpn\_connection\_main\_tunnel1\_preshared\_key](#output\_aws\_vpn\_connection\_main\_tunnel1\_preshared\_key) | For the Main VPN, The preshared key of the first VPN tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel1_vgw_inside_address"></a> [aws\_vpn\_connection\_main\_tunnel1\_vgw\_inside\_address](#output\_aws\_vpn\_connection\_main\_tunnel1\_vgw\_inside\_address) | For the Main VPN, The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side). |
| <a name="output_aws_vpn_connection_main_tunnel2_address"></a> [aws\_vpn\_connection\_main\_tunnel2\_address](#output\_aws\_vpn\_connection\_main\_tunnel2\_address) | For the Main VPN, The public IP address of the second tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel2_bgp_asn"></a> [aws\_vpn\_connection\_main\_tunnel2\_bgp\_asn](#output\_aws\_vpn\_connection\_main\_tunnel2\_bgp\_asn) | For the Main VPN, The bgp asn number of the second VPN tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel2_bgp_holdtime"></a> [aws\_vpn\_connection\_main\_tunnel2\_bgp\_holdtime](#output\_aws\_vpn\_connection\_main\_tunnel2\_bgp\_holdtime) | For the Main VPN, The bgp holdtime of the second VPN tunnel. |
| <a name="output_aws_vpn_connection_main_tunnel2_cgw_inside_address"></a> [aws\_vpn\_connection\_main\_tunnel2\_cgw\_inside\_address](#output\_aws\_vpn\_connection\_main\_tunnel2\_cgw\_inside\_address) | For the Main VPN, The RFC 6890 link-local address of the second VPN tunnel. (Customer Gateway Side). |
| <a name="output_aws_vpn_connection_main_tunnel2_preshared_key"></a> [aws\_vpn\_connection\_main\_tunnel2\_preshared\_key](#output\_aws\_vpn\_connection\_main\_tunnel2\_preshared\_key) | For the Main VPN, The preshared key of the second VPN tunnel. |
<!-- END_TF_DOCS -->