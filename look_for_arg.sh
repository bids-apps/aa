#!/bin/bash
index=0;
found=0;
tmpl=$1;
shift

for i in $*; do
  [ "$i" == "$tmpl" ]
  f=$?
  ((f=!f))
  ((found=found+f))
  ((index+=1))
  if [ "$f" -gt 0 ]; then
    break
  fi
done
((index=index*found))

echo $index
