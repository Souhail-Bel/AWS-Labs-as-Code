# Lab 06: Amazon S3

Part of the free [Introduction to AWS Cloud](https://skillbuilder.aws/learning-plan/JE1AJBF5ZP/builder-labs-introduction-to-aws-cloud/955TYR1UFV) learning plan (lab SPL-TF-100-STESS3).

You create a bucket for report files, control who can read and write to it, then turn on versioing and recover deleted files.

## Run it

This lab involves denying access and Floci only denies when its enforcement settings are on; it's what `floci.env` holds and what `make up` applies:

```fish
make up LAB=06-s3
make start LAB=06-s3
# run lab.ipynb
make end LAB=06-s3
```

If you're switching from antoher lab, run `make reset LAB=...` so Floci restarts with that lab's settings.

## Starting state

`make start LAB=06-s3` creates the role the lab's bastion host runs as `EC2InstanceProfileRole` and its instance profile. The role can list and read S3 but not write to it.

## What to learn

- Objcets are private until a bucket policy or ACL says otherwise, with Block Public Access overriding both
- A bucket policy grants access to the whole bucket, and a polic can name a role or everyone `*`
- With versioning, deleting a file adds a delete marker and removing it restores that file.

## Lab steps in boto3

| Lab step | boto3 call |
|---|---|
| Create bucket with ACLs on | `s3.create_bucket` with `ObjectOwnership` |
| Upload an object | `s3.put_object` |
| Make object public | `s3.put_public_access_block`,`s3.put_object_acl` |
| Test from EC2 instance | `sts.assume_role` then S3 calls with those credentials |
| Create bucket policy | `s3.put_bucket_policy` |
| Enable versioning | `s3.put_bucket_versioning` |
| Show versions | `s3.list_object_versions` |
| Delete, restore and delete a version | `s3.delete_object` with and without `VersionId` |


The lab opens a Session Manager shell on a bastion host. \
Here, neither the shell nor the instance exists, so the notebook assumes the instance's role instead and makes the same calls with its credentials.

While the lab provides you the files you need to upload, the notebook prepares a PNG and text files all within.

## Floci notes

- Without `make up LAB=06-s3` nothing is denied and the notebook fails at the first "private by default" check
- Enforcement applies to every credential except the key `test` which is always allowed. Hence why your own calls work and the assumed role's do not
- Real S3 refuses an anonymous read of an old version when the policy only allows `s3:GetObject`. The check for that in Task 6 fails if Floci does not make the same distinction.
