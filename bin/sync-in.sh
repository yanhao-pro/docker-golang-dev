#!/bin/bash

dst_folder=$PWD
src_folder=${PWD/src-in-vm/src-in-host}
dst="$( cd "$( dirname "${dst_folder}" )" &> /dev/null && pwd )"

if [[ "$1" == "clean" ]]; then
  echo "Sync $src_folder -> $dst with DELETE?"
  read -r -s
  #echo $REPLY

  rsync -avP --delete-after "$src_folder" "$dst"
else
  echo "Sync $src_folder -> $dst ?"
  read -r -s
  #echo $REPLY

  rsync -avP "$src_folder" "$dst"
fi
