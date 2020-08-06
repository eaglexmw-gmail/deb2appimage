#! /bin/bash

DEBS_RELEASE=

function get_release()
{
   OLD_IFS="$IFS"
   IFS=,
   for item_one in $1; 
   do
      RELEASE="$(apt-cache policy $item_one | grep " 500 " | awk '{print $3;}' | sed 's?/[a-z]\+??' | sed -n '1p')"
      DEBS_RELEASE="${DEBS_RELEASE},""$RELEASE"
   done;
   IFS="$OLD_IFS"
}

get_release $1
echo $DEBS_RELEASE
