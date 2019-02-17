#!/bin/bash

if [ ! -f "$1" ]; 
then
  echo "Файл не найден"
  exit
else
	filename=$1
fi

cat /dev/null > available_users

if [ `ls -al "$filename" | grep '^-......r' | wc -l` -gt 0 ]; 
then
	getent passwd | nawk -F: '{print $1}' >> available_users
fi

if [ `ls -al "$filename" | grep '^-...r' | wc -l` -gt 0 ]; 
then
	file_groups=`ls -al "$filename" | grep '^-' | nawk '{ print $4 }'`
	file_gid=`id "$file_groups" | sed 's/^uid=//;s/(.*//'`
	for user in `getent passwd | nawk -F: '{print $1}'`
    do
      if [ `id $user | grep "gid=$file_gid(" | wc -l` -gt 0 ]
      then
        echo $user >> available_users
      fi
    done
fi

if [ `ls -al "$filename" | grep "^-r" | wc -l` -gt 0 ]; 
then
	file_owners=`ls -al "$filename" | grep '^-' | nawk '{ print $3 }'`
  file_uid=`id "$file_owners" | sed 's/^uid=//;s/(.*//'`
  getent passwd $file_uid | nawk -F: '{print $1}' >> available_users
fi

cat available_users | sort | uniq