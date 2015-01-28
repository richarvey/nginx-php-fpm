#!/bin/bash

# Pull down code form git for our site!
if [ ! -z "$GIT_REPO" ]; then
  rm /usr/share/nginx/html/*
  if [ ! -z "$GIT_BRANCH" ]; then
    git clone -b $GIT_BRANCH $GIT_REPO /usr/share/nginx/html/
  else
    git clone $GIT_REPO /usr/share/nginx/html/
  fi
fi

# Tweak nginx to match the workers to cpu's

procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes 5/worker_processes $procs/" /etc/nginx/nginx.conf

# Very dirty hack to replace variables in code with ENVIRONMENT values

for i in $(env)
do
  variable=$(echo "$i" | cut -d'=' -f1)
  value=$(echo "$i" | cut -d'=' -f2)
  if [[ "$variable" != '%s' ]] ; then
    replace='\$\$_'${variable}'_\$\$'
    find /usr/share/nginx/html -type f -exec sed -i -e 's/'${replace}'/'${value}'/g' {} \; ; fi
  done

# Start supervisord and services
/usr/local/bin/supervisord -n
