resource "aws_elb" "rancher-server-lb" {
  name               = "${var.prefix}-rancher-server-lb"
  availability_zones = aws_instance.x86_vms[*].availability_zone

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  instances                   = [
    aws_instance.x86_vms[0].id,
    aws_instance.x86_vms[1].id,
    aws_instance.x86_vms[2].id
  ]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.prefix}-rancher-server-lb"
  }
}

data "digitalocean_domain" "rancher" {
  name = "plgrnd.be"
}

resource "digitalocean_record" "rancher" {
  domain = data.digitalocean_domain.rancher.name
  type   = "CNAME"
  name   = "rancher-demo"
  value  = "${aws_elb.rancher-server-lb.dns_name}."
  ttl    = 60
}
