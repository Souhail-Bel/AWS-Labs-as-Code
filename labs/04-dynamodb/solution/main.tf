resource "aws_dynamodb_table" "music" {
  name         = "Music"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Artist"
  range_key    = "Song"

  attribute {
    name = "Artist"
    type = "S"
  }

  attribute {
    name = "Song"
    type = "S"
  }
}