variable "location" {
  type = string
  description = "Region"
  default = "francecentral"
}

variable "RgCloudInit" {
  type = string
  description = "Resource group Name"
  default = "Last_Cloud_Init_v1"
}

variable "Admin_Password-Cloud-Init" {
  type = string
  description = "Admin Password"
  default = "Admin@123"
}