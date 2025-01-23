#teste local

terraform init -reconfigure -backend-config="${{ env.BACKEND_CONFIG }}"
terraform plan -lock=false -parallelism=10 -out=plan.out -var-file="${{ env.ENVIRONMENT_TFVARS }}"
terraform apply -auto-approve -lock=false -parallelism=10  -var-file="${{ env.ENVIRONMENT_TFVARS }}"