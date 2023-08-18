# GLOBAL
variable "location" {
  type        = string
  default     = "Australia East"
  description = "Define location where resources will be deployed"
}

variable "naming_prefix" {
  type        = string
  default     = "origintest"
  description = "Prefix for naming all deployed resources."
}

variable "tags" {
  type    = list(string)
  default = ["Environment:Dev", "CostCenter:IT"]
}


# VNET
variable "use_for_each" {
  type    = bool
  default = true
}


# PANOS
variable "pan_os_password" {
    type = string
    default = "$mytestpassword123"
    sensitive = true
    description = "Password for the palo alto panorama firewall."
}


# PUBLIC IP
variable "allocation_method" {
  type        = string
  default     = "Static"
  description = "(Required) Defines how an IP address is assigned. Options are Static or Dynamic."
}

variable "pip_ddos_protection_mode" {
  type        = string
  default     = "VirtualNetworkInherited"
  description = "(Optional) The DDoS protection mode of the public IP. Possible values are `Disabled`, `Enabled`, and `VirtualNetworkInherited`. Defaults to `VirtualNetworkInherited`."
}

variable "pip_ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of DDoS protection plan associated with the public IP. `ddos_protection_plan_id` can only be set when `ddos_protection_mode` is `Enabled`."
}

variable "pip_domain_name_label" {
  type        = string
  default     = null
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN.  If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
}

variable "pip_idle_timeout_in_minutes" {
  type        = number
  default     = 4
  description = "(Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. Defaults to `4`."
}

variable "pip_ip_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created. IP Tag `RoutingPreference` requires multiple `zones` and `Standard` SKU to be set."
}

variable "pip_ip_version" {
  type        = string
  default     = "IPv4"
  description = "(Optional) The IP Version to use, `IPv6` or `IPv4`. Defaults to `IPv4`. Changing this forces a new resource to be created. Only `static` IP address allocation is supported for `IPv6`."
}

variable "pip_name" {
  type        = string
  default     = ""
  description = "(Optional) Name of public ip. If it is set, the 'prefix' variable will be ignored."
}

variable "pip_public_ip_prefix_id" {
  type        = string
  default     = null
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created."
}

variable "pip_reverse_fqdn" {
  type        = string
  default     = null
  description = "(Optional) A fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN."
}

variable "pip_sku" {
  type        = string
  default     = "Basic"
  description = "(Optional) The SKU of the Azure Public IP. Accepted values are Basic and Standard."
}

variable "pip_sku_tier" {
  type        = string
  default     = "Regional"
  description = "(Optional) The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`. Defaults to `Regional`. Changing this forces a new resource to be created."
}

variable "pip_zones" {
  type        = list(string)
  default     = null
  description = "(Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default."
}


# LOAD BALANCER
variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Public IP and Load Balancer should exist. Changing this forces new resources to be created."
}

variable "lb_sku" {
  type        = string
  default     = "Basic"
  description = "(Optional) The SKU of the Azure Load Balancer. Accepted values are Basic and Standard."
}

variable "lb_sku_tier" {
  type        = string
  default     = "Regional"
  description = "(Optional) The SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`. Changing this forces a new resource to be created."
}

variable "tracing_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether enable tracing tags that generated by BridgeCrew Yor."
  nullable    = false
}

variable "type" {
  type        = string
  default     = "public"
  description = "(Optional) Defined if the loadbalancer is private or public"
}

variable "frontend_ip_zones" {
  type        = set(string)
  default     = null
  description = "(Optional) A collection containing the availability zone to allocate the IP in. Changing this forces a new resource to be created. Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default."
}

variable "frontend_name" {
  type        = string
  default     = "myPublicIP"
  description = "(Required) Specifies the name of the frontend ip configuration."
}

variable "frontend_private_ip_address" {
  type        = string
  default     = ""
  description = "(Optional) Private ip address to assign to frontend. Use it with type = private"
}

variable "frontend_private_ip_address_allocation" {
  type        = string
  default     = "Dynamic"
  description = "(Optional) Frontend ip allocation type (Static or Dynamic)"
}

variable "frontend_private_ip_address_version" {
  type        = string
  default     = null
  description = "(Optional) The version of IP that the Private IP Address is. Possible values are `IPv4` or `IPv6`."
}