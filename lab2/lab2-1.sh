#!/bin/bash

catalog_name=$1

if [ -z "$catalog_name" ]
then
    catalog_name="$HOME"
fi

if [ -d "$catalog_name" ]
then
    find "$catalog_name" -type f -exec test -x {} \; -print 2>/dev/null | xargs -n 1 basename | sort -r
else
    echo "Ошибка: '$catalog_name' не является директорий" >&2
fi