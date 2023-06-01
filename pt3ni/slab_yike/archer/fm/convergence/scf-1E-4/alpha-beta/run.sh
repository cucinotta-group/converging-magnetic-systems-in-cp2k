#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing

param_1="1.0E-3 4.0E-03 1.0E-2 4.0E-02 8.0E-02 1.0E-1 4.0E-01"
param_2="1.0E-3 4.0E-03 1.0E-2 4.0E-02 8.0E-02 1.0E-1 4.0E-01 1.0 1.5"

job_directory=search
input_file=cp2k.inp
output_file=log.out
job_file=submit.slurm
geometry=struct.xyz

for ii in $param_1 ; do
	for jj in $param_2 ; do
		work_dir=$job_directory/${ii}_${jj}
		if [ -d $work_dir ] ; then
			rm -r $work_dir
		fi
		mkdir $work_dir

		cd $work_dir
		cp -r ../../input .
		cp ../../$job_file .

		sed -i -e "s/ALPHA=4E-2/ALPHA=${ii}/g" $job_file
		sed -i -e "s/BETA=4E-3/BETA=${jj}/g" $job_file

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
