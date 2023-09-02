output "ec2_global_ips" {
  value = aws_eip.tech-blog-eip.*.public_ip
}
