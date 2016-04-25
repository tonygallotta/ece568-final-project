#!/bin/bash

vdds=(1.1 1.2 1.3)
num_cores=1
freqs=(2000 2200 2400 2600 2800 3000 3200 3400 3600 3800)
total_cycles=581463
scale=90

for vdd in ${vdds[@]}; do
  for freq in ${freqs[@]}; do
    config_name=spe_vdd_${vdd}_freq_${freq}
    sed -e s/{{num_cores}}/$(($num_cores+1))/g top.xml > ${config_name}.xml
    cat ppe.xml >> ${config_name}.xml

    for i in $(seq 1 $num_cores); do
      sed -e s/{{core_num}}/core$i/g spe.xml >> ${config_name}.xml
    done

    cat bottom.xml >> ${config_name}.xml
    sed -i bak -e s/{{frequency}}/$freq/g ${config_name}.xml
    sed -i bak -e s/{{scale}}/$scale/g ${config_name}.xml
    sed -i bak -e s/{{vdd}}/$vdd/g ${config_name}.xml
    sed -i bak -e s/{{total_cycles}}/$total_cycles/g ${config_name}.xml
    echo "Running simulation for ${config_name}..."
    ../mcpat -infile ${config_name}.xml > results/${config_name}.out
  done
done

rm *bak
