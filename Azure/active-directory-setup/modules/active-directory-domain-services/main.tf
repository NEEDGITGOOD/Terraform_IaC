resource "azurerm_active_directory_domain_service" "adds" {
  name                = "${var.resource_group_name}-AADS"
  location            = var.location
  resource_group_name = "${var.resource_group_name}"

  domain_name           = "${var.adds_domain_name}"
  sku                   = "Enterprise"
  filtered_sync_enabled = false

  initial_replica_set {
    subnet_id = azurerm_subnet.deploy.id
  }

  security {
    sync_kerberos_passwords = true
    sync_ntlm_passwords     = true
    sync_on_prem_passwords  = true
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.deploy,
  ]
}