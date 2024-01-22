resource "azurerm_subnet_network_security_group_association" "nsg" {
  subnet_id                 = var.subnet_id
  network_security_group_id = var.nsg_id  # This assumes you pass the NSG ID as a variable
}

resource "azurerm_active_directory_domain_service" "adds" {
  name                = "${var.resource_group_name}-AADS"
  location            = var.location
  resource_group_name = var.resource_group_name

  domain_name           = "${var.adds_domain_name}"
  sku                   = "Enterprise"
  filtered_sync_enabled = false

  initial_replica_set {
    subnet_id = var.subnet_id
  }
  security {
    sync_kerberos_passwords = true
    sync_ntlm_passwords     = true
    sync_on_prem_passwords  = true
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.nsg,
  ]
}