#!/bin/bash
if [ "$#" -lt 3 ]; then
  echo "usage: ./make-config.sh <num_cores> <scale (nm)> <config_name> <cycles:4512>"
fi
num_cores=${1:-8}
scale=${2:-90}
config_name=${3:-config}
total_cycles=${4:-4512}
total_instructions=1530000
fp_instructions=30000
int_instructions=1500000
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
sed -i bak -e s/{{total_instructions}}/$total_instructions/g ${config_name}.xml
sed -i bak -e s/{{int_instructions}}/$int_instructions/g ${config_name}.xml
sed -i bak -e s/{{fp_instructions}}/$fp_instructions/g ${config_name}.xml

rm *bak
