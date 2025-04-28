provider "aws" {
  region = var.region
}

provider "cato" {
  account_id = var.account_id
  token      = var.token
  baseurl    = var.baseurl
}

module "ipsec-aws-tgw" {
  source                                = "./modules/test"
  account_id                            = var.account_id
  token                                 = var.token
  aws_transit_gateway_id                = "tgw-somelongguid"
  region                                = var.region
  aws_cgw_bgp_asn                       = 64512 #ASN of TGW //TODO: Change the Var Name
  cato_bgp_asn                          = 65001
  primary_customer_gateway_ip_address   = "216.205.117.206"
  secondary_customer_gateway_ip_address = "150.195.206.169"
  site_name                             = "AWS-Cato-IPSec-Site"
  site_description                      = "AWS Cato IPSec Site US-West-2"
  native_network_range                  = "10.0.0.0/24"
  primary_public_cato_ip_id             = "35982"
  tunnel1_inside_cidr                   = "169.254.100.0/30"
  tunnel2_inside_cidr                   = "169.254.200.0/30"
  tunnel1_preshared_key                 = "1234567890abcdefg"
  tunnel2_preshared_key                 = "1234567890abcdefg"
  #AWS Always takes the 1st IP in the Allocatied Subnet Range
  primary_private_cato_ip     = "169.254.100.2"
  primary_private_site_ip     = "169.254.100.1"
  secondary_public_cato_ip_id = "35984"
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
}