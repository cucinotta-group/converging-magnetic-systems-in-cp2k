#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing, therefore 8x8 grid

param_1="1.0E-3 4.0E-03 1.0E-2 4.0E-02 5.0E-02 1.0E-1 4.0E-01 5.0E-01"
param_2="1.0E-3 4.0E-03 1.0E-2 4.0E-02 4.0E-02 1.0E-1 4.0E-01 5.0E-01"

job_directory=search
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz

for ii in $param_1 ; do
	for jj in $param_2 ; do
		work_dir=$job_directory/${ii}_${jj}
		if [ -d $work_dir ] ; then
			rm -r $work_dir
		fi

		mkdir $work_dir

		sed -e "s/REPLACE_ALPHA/${ii}/g" \
		    -e "s/REPLACE_BETA/${jj}/g" \
			$template_file > $input_file

		cd $work_dir
		cp ../../$input_file .
		cp ../../$job_file .
		cp ../../$geometry .
		cp ../../Pt3Ni-RESTART.kp .
		cd ../..
	done
done

wait

for ii in $param_1 ; do
	for jj in $param_2 ; do
		work_dir=$job_directory/${ii}_${jj}
		cd $work_dir
		if [ -f $output_file ] ; then
			rm $output_file
		fi
		sbatch $job_file
		cd ../..
	done
done

wait


