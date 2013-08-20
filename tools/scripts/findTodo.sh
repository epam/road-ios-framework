#!/bin/sh

KEYWORDS="TODO:|FIXME:|\?\?\?:|\!\!\!:"
find "$1" \( -name "*.h" -or -name "*.m" \) -print0 | \
xargs -0 egrep --ignore-case --with-filename --line-number --only-matching "($KEYWORDS).*\$" | \
perl -p -e "s/($KEYWORDS)/ warning: \$1/i"
echo

