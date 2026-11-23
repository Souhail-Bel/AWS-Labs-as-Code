# Adding a lab

1. Copy `labs/_template` to `labs/NN-service`, with NN the lab's position in the learning plan
2. Fill in `README.md` and `lab.ipynb`. The notebook follows the lab guide with boto3 and ends by deleting what it created.
3. If the lab starts with resources the learner did not create, declare them in `seed/`. If it starts empty, delete `seed/`.
4. If it starts empty you may add `solution/`: the end state in Terraform plus a `verify.py` that checks it. Otherwise delete `solution/`.
5. In each Terraform folder, add an `endpoints` line to `providers.tf` for every service it uses.
6. Run `make test LAB=NN-service`. CI finds lab by its folder name so there is nothing to register.
7. Add the lab to the table in the root README.

## Conventions

- `seed/` is what Skill Builder would have set up. It never contains what the learner builds.
- Terraform declares infrastructure. Data belongs to the notebook.
- Look seeded resources up by tag, _not_ by ID.
- Use `client` by default. Use `resource` only for DynamoDB items, where it handles type conversion. See the [boto3 resources guide](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/resources.html).
- Comments explain why, not what.
- Try and describe labs in your own words/diagrams.
- Run `make fmt` before committing.
