#!/bin/bash

terraform init -reconfigure -backend=true \
               -backend-config="bucket=ap-southeast-1-lab-test-tfstate-files" \
               -backend-config="key=terraform.tfstate" \
               -backend-config="region=ap-southeast-1" \
               -backend-config="profile=lab-test"