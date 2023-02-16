#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing, 16 running

param_1="100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400 2500 2600 2700 2800 2900 3000 3100 3200 3300 3400 3500 4000"

job_directory=search
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz
data_output_1=data.out

rm $data_output_1

for ii in $param_1 ; do
                work_dir=$job_directory/${ii}

                #en_H=$(grep -e '^[ \t]*Total energy' $work_dir/$output_file | awk '{print $3}')
                en_H=$(grep 'Total F' $work_dir/$output_file | awk '{print $9}')
                time=$(grep 'CP2K   ' $work_dir/$output_file  | awk '{print $6}')
                #scf=$(grep 'SCF run converged' $work_dir/$output_file | awk '{print $7}')
                scf=$(grep 'scf_env_do_scf_inner_loop' $work_dir/$output_file | awk '{print $2}')
                iasd=$(grep 'Integrated absolute' $work_dir/$output_file | awk '{print $6}')

                #echo $en_H
                #echo $time
                #echo $scf
                #echo $iasd

                printf "%e %f %d %f %f" $ii $en_H $scf $time $iasd >> $data_output_1
                printf "\n" >> $data_output_1
done
