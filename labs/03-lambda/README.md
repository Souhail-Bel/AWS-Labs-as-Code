# Lab 03: Amazon Lambda

Part of the free [Introduction to AWS Cloud](https://skillbuilder.aws/learning-plan/JE1AJBF5ZP/builder-labs-introduction-to-aws-cloud/955TYR1UFV) learning plan (lab SPL-88).

You build a function that turns every image uploaded to a S3 bucket into a 128px thumbnail in another.

## Starting state

`make start LAB=03-lambda` creates what the lab provides:

- VPC `10.0.0.0/16` with subnet `10.0.1.0/24`
- security group `LambdaSecurityGroup`
- IAM role `lambda-execution-role` which can read/write S3, write logs and attach to a VPC

The function runs inside this VPC.

## What to learn

- few ideas

## Lab steps in boto3

| Lab step | boto3 call |
|---|---|
| | |

Note any step that has no API equivalent and how it's replaced in notebook.

Example is signing in as a user would equivalently be using that user's access keys.

## Optional solution

Only for labs that start empty.

Mention what `solution/` declares and what it leaves to the notebook.

## Floci notes

Where Floci differs from AWS for this lab, and things the lab can't show locally.
