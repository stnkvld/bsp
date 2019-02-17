#!/bin/bash

user_id=`id $1 2>> /dev/null`
if [ $? -eq "1" ];
then
  echo "Пользователя с таким именем не существует"
  exit 
fi

cat /dev/null > available_catalogs

if [ `ls -al | grep '^d.......w' | wc -l` -gt 0 ]; 
then
  ls -al | grep '^d.......w' | nawk '{ print $9 }' >> available_catalogs
fi

IFS=$'\n'
if [ `ls -al | grep '^d....w' | wc -l` -gt 0 ]
then
  for catalog_line in `ls -al | grep '^d....w'`;
    do
      catalog_group=`echo "$catalog_line" | nawk '{ print $4 }'`
      catalog_gid=`id "$catalog_group" | sed 's/^uid=//;s/(.*//'`
      if [ `echo "$user_id" | grep "gid=$catalog_gid(" | wc -l` -gt 0 ]
      then
        echo "$catalog_line" | nawk '{ print $9 }' >> available_catalogs
      fi
    done
fi

if [ `ls -al | grep '^d.w' | wc -l` -gt 0 ]
then
  for catalog_line in `ls -al | grep '^d.w'`;
    do
      catalog_owner=`echo "$catalog_line" | nawk '{ print $3 }'`
      catalog_uid=`id "$catalog_owner" | sed 's/^uid=//;s/(.*//'`
      if [ `echo "$user_id" | grep "uid=$catalog_uid(" | wc -l` -gt 0 ]
      then
        echo "$catalog_line" | nawk '{ print $9 }' >> available_catalogs
      fi
    done
fi
unset IFS

cat available_catalogs | sort | uniq