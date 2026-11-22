#!/usr/bin/env bash
# USAGE: tf.sh <lab-dir> <seed|solution> <apply|destroy>
# Runs Terraform in one folder of a lab
set -euo pipefail

lab=$1 stage=$2 action=$3
dir="$lab/$stage"

if [ ! -d "$dir" ]; then
  echo "$lab has no $stage/, skipping..."
  exit 0
fi

terraform -chdir="$dir" init -input=false
terraform -chdir="$dir" "$action" -auto-approve -input=false \
  -var "use_floci=${USE_FLOCI:-true}"
