#!/usr/bin/env bash
set -e

secret=false

while getopts "s" OPTION; do
  case $OPTION in
    s)
      echo "Setting secrets"
      secret=true
      shift $((OPTIND-1))
      ;;
    *)
      echo "Usage: $(basename "$0") [-s] <env_vars>"
      exit 1
      ;;
  esac
done

if [ -z "$1" ]; then
    echo "No argument supplied"
    exit 1
fi

while IFS='=' read -r env_var env_var_value; do
  trimmed_value=${env_var_value%$'\r'}

  if [ "$secret" = true ]; then
    echo "::add-mask::${trimmed_value}"
  fi
    echo "${env_var}=${trimmed_value}" >> "$GITHUB_ENV"
done <<< "${1}"

exit 0
