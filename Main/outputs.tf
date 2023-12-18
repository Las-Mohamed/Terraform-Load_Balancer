output "Rg_Cloud_Init" {
  value = module.Cloud-Init.rg_init
}

output "Location_Init" {
  value = module.Cloud-Init.rg_init_location
}

output "Ip_Cloud_Init" {
  value = module.Cloud-Init.Ip_Init
}

output "Rg_name" {
    value = module.Cluster-Load-Balanced.Rg_child_name
}

output "location" {
  value = module.Cluster-Load-Balanced.Rg_child_ocation
}

output "Ip_Load_Balancer" {
  value = module.Cluster-Load-Balanced.Ip
}

output "Admin_Password" {
    value = module.Cluster-Load-Balanced.motdepasse
    sensitive = true
}

output "Tenant_id" {
  value = module.Cluster-Load-Balanced.Tenant
}