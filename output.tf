output "public_ip_address_ipv4" {
  value = [for ip in aws_instance.veilid-node[*].public_ip : ip]
}

output "public_ip_address_ipv6" {
  value = flatten([for ip in aws_instance.veilid-node[*].ipv6_addresses : ip])
}
