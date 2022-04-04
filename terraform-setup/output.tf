output "x86_node_ips" {
  value = aws_instance.x86_vms.*.public_ip
}
output "arm_node_ips" {
  value = aws_instance.arm_vms.*.public_ip
}
output "rancher_domain" {
  value = digitalocean_record.rancher.fqdn
}
output "rancher_cluster_ips" {
  value = [
    aws_instance.x86_vms.0.public_ip,
    aws_instance.x86_vms.1.public_ip,
    aws_instance.x86_vms.2.public_ip,
  ]
}
output "all_node_ips" {
  value = concat(
    aws_instance.x86_vms.*.public_ip,
    aws_instance.arm_vms.*.public_ip,
  )
}