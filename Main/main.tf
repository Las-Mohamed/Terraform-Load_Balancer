#module "Cluster-Load-Balanced" {
#    source = "../Cluster-Load-Balanced"
##    location = "francecentral" # ecrase la valeur par défault de location
##    location = null
##    Rgname = null
#}
#
#module "Cloud-Init" {
#    source = "../Cloud-Init"
#    location = "westeurope"
#}

#module "Web-App" {
#    source = "../Web-App"
#}

module "SqlDB" {
    source = "../SqlDB"
}