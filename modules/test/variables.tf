##AWS Variables## 

variable "customer_bgp_asn" {
  description = "Customer Side BGP ASN"
  default     = null
  type        = string
}

variable "primary_customer_gateway_ip_address" {
  description = "Customer Gateway IP Address"
  default     = null
  type        = string
}

variable "secondary_customer_gateway_ip_address" {
  description = "Customer Gateway IP Address"
  default     = null
  type        = string
}

variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "aws_transit_gateway_id" {
  description = "AWS Transit Gateway ID"
  type        = string
}

variable "tunnel1_inside_cidr" {
  description = "Tunnel 1 Inside CIDR"
  type        = string
}

variable "tunnel2_inside_cidr" {
  description = "Tunnel 2 Inside CIDR"
  type        = string
}

variable "tunnel1_preshared_key" {
  description = "Tunnel 1 Preshared Key"
  type        = string
}

variable "tunnel2_preshared_key" {
  description = "Tunnel 2 Preshared Key"
  type        = string
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

variable "primary_public_cato_ip_id" {
  description = "Public IP address ID of the Cato side for the primary tunnel"
  type        = string
}

variable "primary_destination_type" {
  description = "The destination type of the IPsec tunnel"
  # validation {
  #   condition     = var.primary_destination_type == null || contains(["FQDN","IPv4"], var.primary_destination_type)
  #   error_message = "The site_type variable must be one of 'FQDN','IPv4'."
  # }
  # nullable    = true
  type    = string
  default = null
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

variable "secondary_public_cato_ip_id" {
  description = "Public IP address ID of the Cato side for the secondary tunnel"
  type        = string
}

variable "secondary_destination_type" {
  description = "The destination type of the IPsec tunnel"
  # validation {
  #   condition     = var.secondary_destination_type == null || contains(["FQDN","IPv4"], var.secondary_destination_type)
  #   error_message = "The destination_type variable must be one of 'FQDN','IPv4'."
  # }
  # nullable    = true
  type    = string
  default = null
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