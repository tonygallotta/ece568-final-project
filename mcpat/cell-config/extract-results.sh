#!/bin/bash

cd results/

for file in $(ls -1); do
  freq=$(echo "$file" | awk -F '_' '{print $5}' | awk -F '.' '{print $1}')
  vdd=$(echo "$file" | awk -F '_' '{print $3}')
  echo $freq,$vdd,$(sed "125q;d" $file | awk '{print $4}')
done
cd - > /dev/null
