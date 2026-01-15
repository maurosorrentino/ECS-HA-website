resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = module.project_name_alb_logs_s3.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowALBPutObject",
        Effect : "Allow",
        Principal : {
          Service : "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        Action : "s3:PutObject",
        Resource : [
          "${module.project_name_alb_logs_s3.bucket_arn}/${local.s3_frontend_alb_prefix}/AWSLogs/${local.account_id}/*",
          "${module.project_name_alb_logs_s3.bucket_arn}/${local.s3_backend_alb_prefix}/AWSLogs/${local.account_id}/*"
        ],
        Condition : {
          StringEquals : {
            "s3:x-amz-acl" : "bucket-owner-full-control",
            "aws:SourceAccount" : local.account_id
          },
          # need to allow all the ALBs in the account to write logs to the same bucket otherwise it won't work
          # as when tf creates the ALB and s3 needs to allow it to write logs
          # TODO put name of alb in locals and use that?
          ArnLike = {
            "aws:SourceArn" = "arn:aws:elasticloadbalancing:${var.region}:${local.account_id}:loadbalancer/*"
          }
        }
      },
      {
        Sid    = "AllowALBGetBucketAcl",
        Effect = "Allow",
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = module.project_name_alb_logs_s3.bucket_arn,
        Condition : {
          StringEquals : {
            "aws:SourceAccount" : local.account_id
          },
          ArnLike = {
            "aws:SourceArn" = "arn:aws:elasticloadbalancing:${var.region}:${local.account_id}:loadbalancer/*"
          }
        }
      },
      {
        Sid : "AllowVPCEndpointAccess",
        Effect : "Allow",
        Principal : "*",
        Action : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource : [
          module.project_name_alb_logs_s3.bucket_arn,
          "${module.project_name_alb_logs_s3.bucket_arn}/${local.s3_frontend_alb_prefix}/AWSLogs/${local.account_id}/*",
          "${module.project_name_alb_logs_s3.bucket_arn}/${local.s3_backend_alb_prefix}/AWSLogs/${local.account_id}/*"
        ],
        Condition : {
          StringEquals : {
            "aws:SourceVpce" : aws_vpc_endpoint.project_name_s3_alb_logs_vpc_endpoint.id
          }
        }
      }
    ]
  })

  depends_on = [module.project_name_alb_logs_s3, aws_vpc_endpoint.project_name_s3_alb_logs_vpc_endpoint]
}

resource "aws_s3_bucket_policy" "cloudfront_logs_policy" {
  bucket = module.project_name_cloudfront_logs_s3.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowCloudFrontLogs",
        Effect : "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${module.project_name_cloudfront_logs_s3.bucket_arn}/AWSLogs/${local.account_id}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      },
      {
        Sid : "AllowBucketAclCheck",
        Effect : "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = module.project_name_cloudfront_logs_s3.bucket_arn
      }
    ]
  })

  depends_on = [module.project_name_cloudfront_logs_s3]
}
