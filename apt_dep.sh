#! /bin/bash

SKIP_DEP=libc6
ALL_DEBS=$1
CHECKED_DEBS="$1,libc6"
UNCHECK_DEBS=""

function is_check()
{
	OLD_IFS="$IFS"
	IFS=,
    for item_one in ${CHECKED_DEBS}; do
        if [ $item_one == $1 ]; then
             IFS="$OLD_IFS"
             return 1
        fi
    done;
    IFS="$OLD_IFS"
    return 0
}

function get_dep()
{
   PACKAGE_NAME="$1"
   DEPS_NAME="$(apt-cache depends "$PACKAGE_NAME" | grep " 依赖:" | awk -F ":" '{ print $2}' | tr -d '<>' | tr '\n' ' ')"
   # echo "$1, ${DEPS_NAME}"
   for item_two in ${DEPS_NAME}; 
   do
      is_check $item_two
      if [ $? -eq 0 ] ; then
         CHECKED_DEBS="${CHECKED_DEBS},""$item_two"
         get_dep $item_two
      fi
   done;
}

get_dep $1
echo ${CHECKED_DEBS}
