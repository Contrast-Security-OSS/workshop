output "public_ip" {
  value = "RDP to ${azurerm_public_ip.public.ip_address} (default username is `azure` and default password is `ContrastRocks123!`)"
}