#print out ip address of machine instances
output "instance_public_ip" {
  value = aws_instance.trial-server.*.public_ip
}

output "instance_public_dns" {
  value = aws_instance.trial-server.*.public_dns
}

output "numberofsystems" {
  value = length(aws_instance.trial-server)
}
