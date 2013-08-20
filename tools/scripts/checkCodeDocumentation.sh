#!/bin/sh

# $1 - path to appledoc folder - templates and binary should be in this folder
# $2 - path to source to check

"$1/appledoc" -t "$1/" --project-name SPARK-DEV --project-company Epam\ Systems --company-id com.epam --output /tmp --no-install-docset --warn-undocumented-object --warn-undocumented-member --keep-undocumented-objects --keep-undocumented-members --no-warn-invalid-crossref --logformat xcode --exit-threshold 2 --ignore "*.m" "$2"

