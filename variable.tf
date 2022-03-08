variable "subscription_id" {}
variable "tenant_id" {}
variable "linux_vm_image_publisher_debian_11" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "Debian"
}
variable "linux_vm_image_offer_debian_11" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "debian-11"
}
variable "debian_11_sku" {
  type        = string
  description = "SKU for latest Debian 11"
  default     = "11"
}
variable "debian_11_gen2_sku" {
  type        = string
  description = "SKU for latest Debian 11"
  default     = "11-gen2"
}
