variable "subscription_id" {}
variable "tenant_id" {}
variable "administrator_login" {}
variable "administrator_login_password" {}



variable "linux_vm_image_publisher_debian_11" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "Debian"
}
