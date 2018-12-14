#!/bin/bash

process_quantity=$1

if [ -z "$process_quantity" ]
then
    process_quantity=0
fi

ps -u "$(echo $(w -h | cut -d ' ' -f1 | sort -u))" -o user= | sort | uniq -c | nawk -v process_quantity=$1 '{if ($1 > process_quantity) print $2}'
