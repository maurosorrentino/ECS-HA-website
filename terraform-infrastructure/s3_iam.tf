resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = module.project_name_alb_logs_s3.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowALBPutObject",
        Effect : "Allow",
        Principal : {
          Service : "elasticloadbalancing.amazonaws.com"
        },
        Action : "s3:PutObject",
        # try first with /* and then s3_prefix
        Resource : [
          "arn:aws:s3:::${module.project_name_alb_logs_s3.bucket_id}/frontend-alb-logs/AWSLogs/*",
          "arn:aws:s3:::${module.project_name_alb_logs_s3.bucket_id}/backend-alb-logs/AWSLogs/*"
        ],
        Condition : {
          StringEquals : {
            "aws:SourceAccount" : data.aws_caller_identity.current.account_id
          },
          # need to allow all the ALBs in the account to write logs to the same bucket otherwise it won't work
          # as when tf creates the ALB it s3 needs to allow it to write logs
          ArnLike = {
            "aws:SourceArn" = [
              "arn:aws:elasticloadbalancing:${var.region}:${data.aws_caller_identity.current.account_id}:loadbalancer/*"
              # module.project_name_frontend_alb.alb_arn,
              # module.project_name_backend_alb.alb_arn
            ]
          }
        }
      },
      {
        Sid = "AllowALBGetBucketAcl",
        Effect = "Allow",
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        },
        Action = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::${module.project_name_alb_logs_s3.bucket_id}"
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
          "arn:aws:s3:::${module.project_name_alb_logs_s3.bucket_id}",
          "arn:aws:s3:::${module.project_name_alb_logs_s3.bucket_id}/*"
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
  #module.project_name_frontend_alb.alb_arn, module.project_name_backend_alb.alb_arn]
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
        Resource = "arn:aws:s3:::${module.project_name_cloudfront_logs_s3.bucket_id}/*",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
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
        Resource = "arn:aws:s3:::${module.project_name_cloudfront_logs_s3.bucket_id}"
      }
    ]
  })
}
