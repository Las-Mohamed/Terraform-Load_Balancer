variable "location" {
  type = string
  description = "Region"
  default = "francecentral"
}

variable "Rgname" {
  type = string
  description = "Resource group Name"
  default = "Last_Terraform"
}

variable "Admin_Password" {
  type = string
  description = "Admin Password"
  default = "Admin@123"
}