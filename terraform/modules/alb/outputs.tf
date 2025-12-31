output "alb_sg" {
    value = aws_alb.project_alb_sg.id
    description = "The security group ID of the ALB"
}

output "alb_tg_arn" {
    value = aws_lb_target_group.project_alb_tg.arn
    description = "The ARN of the ALB target group"
}