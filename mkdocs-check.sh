#!/bin/bash

working_dir="$PWD"

for mkdocs in $(find . -name mkdocs.yaml 2>/dev/null); do
  docs_dir=$(dirname $mkdocs)

  echo "info: Running command 'mkdocs build $docs_dir' ..."

  if [ $docs_dir = "." ]; then
    build_dir="/tmp/root"
  else
    build_dir="/tmp/$docs_dir"
  fi

  cd $docs_dir

  output=$(mkdocs build -d $build_dir 2>&1)
  errors=$(echo "$output" | grep ERROR)

  if [ -z "$errors" ]; then
    warnings=$(echo "$output" | grep WARNING)

    if [ -z "$warnings" ]; then
        echo "info: Build suceeded"
    else
        echo "error: Build failed returning the following WARNINGs:"
        echo ""
        echo "$warnings"
        exit 1
    fi

  else
    echo "error: Build failed returning the following ERRORs:"
    echo ""
    echo "$errors"
    exit 1
  fi

  echo ""
  cd $working_dir

done
