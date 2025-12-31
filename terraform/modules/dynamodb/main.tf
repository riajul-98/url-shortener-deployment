resource "aws_dynamodb_table" "project_dynamodb_table" {
  name           = "${var.environment}-project-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
    tags = merge(
        local.tags,
        {
        Name        = "${var.environment}-project-dynamodb-table"
        Environment = var.environment
        }
    )
}