output "user_data_hash" {
  value = filesha256("${path.module}/openvpn.sh")
}