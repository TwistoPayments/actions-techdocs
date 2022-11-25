#!/bin/bash

working_dir="$PWD"

for mkdocs in $(find . -name mkdocs.yaml 2>/dev/null); do
  docs_dir=$(dirname $mkdocs)

  echo "info: Found mkdocs.yaml in $docs_dir ..."

  if [ $docs_dir = "." ]; then
    build_dir="/tmp/root"
  else
    build_dir="/tmp/$docs_dir"
  fi

  cd $docs_dir

  if [[ ! -f 'catalog-info.yaml' ]]; then
    echo "warning: $build_dir/catalog-info.yaml not found"
    continue
  fi

  catalog_info=$(cat catalog-info.yaml)

  kind=$(echo "$catalog_info" | shyaml get-value kind)
  name=$(echo "$catalog_info" | shyaml get-value metadata.name)
  namespace=$(echo "$catalog_info" | shyaml get-value metadata.namespace default)
  entity_name="$namespace/$kind/$name"

  echo "info: Docs for entity $entity_name generating ..."
  techdocs-cli generate --output-dir $build_dir --no-docker --verbose

  echo "info: Docs for entity $entity_name publishing ..."
  techdocs-cli publish --publisher-type $TECHDOCS_PUBLISHER_TYPE --storage-name $TECHDOCS_S3_BUCKET_NAME --directory $build_dir --entity $entity_name

  echo "info: Docs for entity $entity_name published"
  echo ""

  cd $working_dir

done
