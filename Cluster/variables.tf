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

variable "Object_id" {
  type = string
  description = "Oject_id is longer returned with data source instead use it as a declared variable" 
  # (to find it use in Cli "az account show --query "{subscriptionId:id, tenantId:tenantId, objectId:id})"
  default = "393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"
}