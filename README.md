# AWS Labs as Code

AWS Builder Labs rebuilt with boto3 and Terraform, runs locally on Floci (AWS account not needed).

The free [Builder Labs: Introduction to AWS Cloud](https://skillbuilder.aws/learning-plan/JE1AJBF5ZP/builder-labs-introduction-to-aws-cloud/955TYR1UFV) learning plan teaches AWS through the console. Here each lab works the same way, but in code:

```
make start    Terraform sets up the lab (Start Lab)
lab.ipynb     Follow lab guide in boto3
make end      Tarraform tears down lab  (End Lab)
```

Labs starting empty don't require set up.

You'll find in each lab a `solution/` Terraform, to compare `boto3` API calls you made with declared end state.

I'm mainly targeting [Floci](https://github.com/floci-io/floci), a free local AWS emulator. Though the same code can run against real AWS with an account. _Unfortunately, I couldn't get a chance to try that, since my CTI here in Tunisia is seemingly useless._


## Quick start

You need uv, Terraform 1.5 or newer, and Docker (Floci CLI is accepted through `FLOCI_RUNTIME=cli`)

```fish
cp .env.example .env
uv sync
make up
make start LAB=01-vpc
uv run jupyter lab
make end LAB=01-vpc
```

`make help` lists every command.

## What we will learn

- mapping between console steps in the lab and `boto3` API calls, seeing what the console was doing for you
- declaring infrastructure in **Terraform**: resources, dependencies, plan, apply, destroy (eventually drift)
- understanding the difference between imperitvely perfomring steps through `boto3`, and declaratively by describing a result and working out the steps with Terraform
- testing cloud code locally via an emulator like **Floci**

## Repo philosophy

Pick one lab.

Read its `README.md` then work through `lab.ipynb`.

If the lab has `seed/`, run `make start` first to set your lab.

If it has a `solution/`, finish the notebook before opening it, then compare the Terraform with the API calls you made.

## Layout

```
labs/NN-name/
  README.md      the lab, and how each step maps to boto3
  lab.ipynb      the boto3 walkthrough
  seed/          Terraform setup (only if it starts non-empty)
  solution/      optional Terraform for the end state (if it starts empty)
labs/_template/  copy this to add a lab
versions.env     the Floci version this repo targets
```

## Labs

| # | Lab | Status |
|---|-----|--------|
| 01 | Amazon VPC | planned |
| 02 | Amazon EC2 | planned |
| 03 | AWS Lambda | planned |
| 04 | Amazon DynamoDB | [done](labs/04-dynamodb/README.md) |
| 05 | Amazon API Gateway | planned |
| 06 | Amazon S3 | [done](labs/06-s3/README.md) |
| 07 | AWS IAM | planned |
| 08 | Basic audit of an AWS environment | planned |
| 09 | AWS KMS | planned |
| 10 | Amazon CloudFront | planned |

## Floci

Pick how Floci runs with `FLOCI_RUNTIME`:

```fish
make up                      # Docker (default)
make up FLOCI_RUNTIME=cli    # the floci CLI
```

> [!IMPORTANT]
> Be mindful of `floci.env` per lab.
> There are environment variables like `FLOCI_SERVICES_IAM_ENFORCEMENT_ENABLED` and `FLOCI_SERVICES_S3_ENFORCE_AUTH` that need to be set for priviliged access

The version this repo targets is set in [`versions.env`](versions.env). Docker runs that image tag.

With the CLI, install the same version.

Floci's web console is at http://localhost:4566/_floci/ui.

## Using real AWS

Remove `AWS_ENDPOINT_URL` from `.env` and add your own credentials. Pass `USE_FLOCI=false` to `make`, for example `make start LAB=02-ec2 USE_FLOCI=false`. Some labs create billable resources (the VPC lab has a NAT gateway), so read the lab README first and clean up later on.

## Limits

Floci is an emulator, not AWS. Each lab README notes where behavior differs.

## Disclaimer

Unofficial. Not affiliated with or endorsed by AWS. The labs belong to AWS; this repo describes them in its own words and links to them.

MIT licensed, see [LICENSE](LICENSE).
