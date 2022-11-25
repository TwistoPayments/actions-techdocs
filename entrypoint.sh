#!/bin/bash

if [ "$1" = "check" ]; then
  mkdocs-check
elif [ "$1" = "publish" ]; then
  techdocs-publish
else
  echo "Unknown command."
fi
