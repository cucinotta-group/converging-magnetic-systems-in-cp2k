#!/bin/bash
  
param_1=("2" "3"  "4" "5" "6" "7" "8" "9" "10" "12" "20")

length=${#param_1[@]}
loops=length-1
echo "Number of runs" $length

folder_1=raw_official_4e-2_4e-3_16_100_2000

for (( i=0; i<loops; i++ )); do
		
		cp -r ${folder_1}_1-1-1 ${folder_1}_${param_1[i]}-${param_1[i]}-1
		sed -i -e "s/KPOINTS=1/KPOINTS=${param_1[i]}/g" ${folder_1}_${param_1[i]}-${param_1[i]}-1/scf-1E-2/submit.slurm

done
