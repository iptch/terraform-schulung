#!/usr/bin/env bash

function pipeline() {
  INSTANCE="$1"
  echo "Running pipeline for workspace: $INSTANCE"

  echo "------------------------------------------"
  echo "Run terraform init"
  terraform init
  echo "------------------------------------------"
  echo "Run terraform workspace"
  terraform workspace select $INSTANCE || terraform workspace new $INSTANCE
  echo "------------------------------------------"
  echo "Run terraform validate"
  terraform validate
  echo "------------------------------------------"
  echo "Run terraform fmt"
  terraform fmt
  echo "------------------------------------------"
  echo "Run tflint"
  tflint
  echo "------------------------------------------"
  echo "Run trviy"
  trivy config .
  echo "------------------------------------------"
  echo "Run plan"
  terraform plan -out tfplan

  echo "------------------------------------------"
  echo "Run trivy on plan"
  terraform show -json tfplan > tfplan.json
  trivy config tfplan.json
  rm tfplan.json

  read -p "Apply plan? [(Yy)es|no] " apply

  if [[ "$apply" == "Y" || "$apply" == "y" ]]; then
    echo "------------------------------------------"
    echo "Run terraform apply"
    terraform apply tfplan
  fi
  rm tfplan
}


pipeline $1