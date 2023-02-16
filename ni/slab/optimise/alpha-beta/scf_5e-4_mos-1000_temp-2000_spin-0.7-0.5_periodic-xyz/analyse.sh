#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing, 16 running

param_1="1.0E-3 4.0E-03 1.0E-2 4.0E-02 8.0E-02 1.0E-1 4.0E-01"
param_2="1.0E-3 4.0E-03 1.0E-2 4.0E-02 8.0E-02 1.0E-1 4.0E-01 1.0 1.5"

job_directory=search
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz
data_output_1=data.out

rm $data_output_1

for ii in $param_1 ; do
	for jj in $param_2 ; do
		work_dir=$job_directory/${ii}_${jj}

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

		printf "%e %e %f %d %f %f" $ii $jj $en_H $scf $time $iasd >> $data_output_1
    		printf "\n" >> $data_output_1
	done
done


