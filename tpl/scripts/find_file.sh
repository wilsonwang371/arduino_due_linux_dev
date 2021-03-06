#!/usr/bin/env bash
# find_file.sh <search_root_dir> <partial_name> [exe, dir, file, ar]

if [ $# -ne 3 ]
then
    exit 1
fi
files=""
if [[ "$1" == *:* ]]
then
    SEARCH_ROOT=${1//:/ }
    for i in ${SEARCH_ROOT}
    do
        tmp=$(find "$i" | grep "$2")
        if [ "${tmp}" != "" ]
        then
            files="${files} ${tmp}"
        fi
    done
else
    SEARCH_ROOT=$1
    files=$(find "$1" | grep "$2")
fi
if [ "$3" == "dir" ]
then
    target="directory"
elif [ "$3" == "exe" ]
then
    target="executable"
elif [ "$3" == "ar" ]
then
    target="archive"
elif [ "$3" == "file" ]
then
    target="ANY"
fi
if [ "${target}" == "" ]
then
    exit 1
fi
for i in ${files}
do
    tmptype=$(file $i)
    if [ "${target}" == "ANY" ]
    then
        echo -n $i
        break
    elif [[ "${tmptype}" == *${target}* ]]
    then
        echo -n $i
        break
    fi
done
