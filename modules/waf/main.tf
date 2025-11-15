##################################
# AWS WAFv2 Web ACL Configuration
##################################

resource "aws_wafv2_web_acl" "this" {
  name        = "${var.project_name}-web-acl"
  description = "WAF for ${var.project_name}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
  }

  # -----------------------
  # Rule 1: Rate limiting
  # -----------------------
  rule {
    name     = "LimitRequestsPer5Seconds"
    priority = 1
    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "rateLimit"
    }
  }

  # -----------------------
  # Rule 2: Block Bad Bots
  # -----------------------
  rule {
    name     = "BlockUserAgentBot"
    priority = 2
    action {
      block {}
    }

    statement {
      byte_match_statement {
        search_string = "BadBot"
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        positional_constraint = "CONTAINS"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "blockBadBot"
    }
  }
}

##################################
# Associate WAF with ALB (Beanstalk)
##################################

resource "aws_wafv2_web_acl_association" "assoc" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn

  depends_on = [
    aws_wafv2_web_acl.this
  ]
}
