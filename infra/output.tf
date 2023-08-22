output "ec2_global_ips" {
  value = aws_instance.tech-blog-server.*.public_ip
}
