"""CHECK that terraform apply produced the table the lab builds"""

import boto3

music_table = boto3.resource('dynamodb').Table('Music')

assert music_table.key_schema == [
  {"AttributeName": "Artist", "KeyType": "HASH"},
  {"AttributeName": "Song",   "KeyType": "RANGE"},
]

print("Solution OK")