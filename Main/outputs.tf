output "Rg_name" {
    value = module.Cluster.Rg_child_name
}

output "location" {
  value = module.Cluster.Rg_child_ocation
}

output "Ip_publique" {
  value = module.Cluster.Ip
}

output "Admin_Password" {
    value = module.Cluster.motdepasse
    sensitive = true
}