# Lab 04: Amazon DynamoDB

Part of the free [Introduction to AWS Cloud](https://skillbuilder.aws/learning-plan/JE1AJBF5ZP/builder-labs-introduction-to-aws-cloud/955TYR1UFV) learning plan (lab SPL-71).

You build a `Music` table, store songs in it, modify one, read them in 2 ways, and delete the table.

You can read more about the boto3 calls used [here](https://docs.aws.amazon.com/boto3/latest/guide/dynamodb.html).

## Starting state

Empty

## What to learn

- A table needs `partition key`, and optionally `sort key` making the pair unique per item. `Artist` + `Song` uniquely identifies a song.
- No fixed schema beyond keys. Items can carry different attributes.
- A query reads only items matching a key, a scan reads everything and filters afterwards.

## Lab steps in boto3

| Lab step | boto3 call |
|---|---|
| Create the `Music` table | `create_table`, wait until active |
| Add three items | `put_item` |
| Change the year for Psy | `update_item` |
|Query by key| `query` |
| Scan with a filter | `scan` |
|Delete the table|`delete_table`|

## Optional solution

`solution/` declares the same table in Terraform. Do the notebook first, then compare `create_table` with `aws_dynamodb_table`.

Terraform only declares the table. The items stay with boto3, since they are data and not infrastructure.

```fish
make solution LAB=04-dynamodb
make solution-end LAB=04-dynamodb
```

## Try this: drift

```fish
make solution LAB=04-dynamodb
uv run --env-file .env python -c "import boto3; boto3.client('dynamodb').delete_table(TableName='Music')"
terraform -chdir=labs/04-dynamodb/solution plan -var use_floci=true
```

Terraform notices the table is gone and plans to create it again. \
`terraform apply` restores it, which the notebook can't do for you. \
Clean up with `make solution-end LAB=04-dynamodb`.

## Floci notes

DynamoDB runs inside Floci itself, so this lab needs no extra containers.
