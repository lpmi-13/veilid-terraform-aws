output "public_ip_address" {
  value = [for ip in aws_instance.veilid-node[*].public_ip : ip]
}
