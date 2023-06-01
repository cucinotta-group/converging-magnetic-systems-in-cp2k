#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing

param_1="0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4"
param_2="0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4"

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

		sed -i -e "s/SPIN_2_1=1.0/SPIN_2_1=${ii}/g" $job_file
                sed -i -e "s/SPIN_2_2=1.0/SPIN_2_2=${jj}/g" $job_file
		sed -i -e "s/SPIN_2_3=1.0/SPIN_2_3=${ii}/g" $job_file
		
		#sed -i -e "s/ALPHA=4E-2/ALPHA=${ii}/g" $job_file
		#sed -i -e "s/BETA=4E-3/BETA=${jj}/g" $job_file

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
