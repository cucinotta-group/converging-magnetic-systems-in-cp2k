#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing, therefore 8x8 grid

param_1="4 6 8 10 12 14 16"
param_2="0 2 4 6 8 10 12 14"

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

		MULTIPLICITY=$( bc -l <<<"(2*0.5*${ii}+2*0.5*${jj})+1" )
		MULTIPLICITY_INT=${MULTIPLICITY%.*}
		MAGNETIZATION_Ni="${ii}\/8"
		MAGNETIZATION_Pt="${jj}\/24"

		sed -e "s/REPLACE_Ni/$MAGNETIZATION_Ni/g" \
		    -e "s/REPLACE_MULTIPLICITY/$MULTIPLICITY_INT/g" \
		    -e "s/REPLACE_Pt/$MAGNETIZATION_Pt/g" \
			$template_file > $input_file

		cd $work_dir
		cp ../../$input_file .
		cp ../../$job_file .
		cp ../../$geometry .
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


