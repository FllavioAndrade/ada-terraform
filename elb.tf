resource "aws_lb_target_group" "tg-elb" {
  name     = "target-group-elb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ada_vpc.id
  health_check {

    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  
}

resource "aws_lb" "elb-ada" {
  name               = "elb-ada"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public-a.id, 
                        aws_subnet.public-b.id,
                        aws_subnet.public-c.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.ada_bucket.id
    prefix  = "ada -elb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group_attachment" "EC2-a_instance" {
  target_group_arn = aws_lb_target_group.tg-elb.arn      
  target_id        = aws_instance.EC2-a.id
  port             = 80                                  
}

resource "aws_lb_target_group_attachment" "EC2-b_instance" {
  target_group_arn = aws_lb_target_group.tg-elb.arn      
  target_id        = aws_instance.EC2-b.id
  port             = 80                    
}

resource "aws_lb_target_group_attachment" "EC2-c_instance" {
  target_group_arn = aws_lb_target_group.tg-elb.arn     
  target_id        = aws_instance.EC2-c.id
  port             = 80                    
}