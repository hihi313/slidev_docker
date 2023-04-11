#!/bin/bash

MD_FILENAME=slides.md

# Check if there are any .md files
count=`ls -1 *.md 2>/dev/null | wc -l`
if [ $count != 0 ]; then
    # True
    echo "Found *.md file(s)"
else
    # False
    echo "*.md not found"
    cp -f /usr/local/lib/node_modules/@slidev/cli/template.md $PWD/${MD_FILENAME}
    chmod 777 ${MD_FILENAME}
fi

exec "$@"