#!/bin/bash
if [ "$#" -ne 3 ]; then
  echo "usage: ./make-config.sh <num_cores> <scale (nm)> <config_name>"
fi
num_cores=${1:-8}
scale=${2:-90}
config_name=${3:-config}
total_cycles=581463
vdd=0
freq=3200

sed -e s/{{num_cores}}/$(($num_cores+1))/g top.xml | sed -e s/{{scale}}/$scale/ > ${config_name}.xml
cat ppe.xml >> ${config_name}.xml

for i in $(seq 1 $num_cores); do
  sed -e s/{{core_num}}/core$i/g spe.xml >> ${config_name}.xml
done

cat bottom.xml >> ${config_name}.xml

sed -i bak -e s/{{vdd}}/$vdd/g ${config_name}.xml
sed -i bak -e s/{{frequency}}/$freq/g ${config_name}.xml
sed -i bak -e s/{{total_cycles}}/$total_cycles/g ${config_name}.xml
rm *bak
