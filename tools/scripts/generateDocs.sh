#!/bin/sh

"$1/appledoc" -t "$1/" --project-name ESDFW --project-company Epam\ Systems --company-id com.epam --output ../../doc/ --no-install-docset  --ignore "*.m" "$2"