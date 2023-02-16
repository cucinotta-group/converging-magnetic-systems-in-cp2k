#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing, therefore 8x8 grid

#param_2="0.5 0.6 0.7 0.8 0.9 1.0"
param_1=$(seq 0.2 0.01 0.8)

param_2="0.8"


job_directory=search
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz

ATOMS_1=16.0
ATOMS_2=16.0

for ii in $param_1 ; do
	for jj in $param_2 ; do
		work_dir=$job_directory/${ii}_${jj}
		if [ -d $work_dir ] ; then
			rm -r $work_dir
		fi

		mkdir $work_dir

		SPIN_1=${ii}
		SPIN_2=${jj}

		MULTIPLICITY=$(bc -l <<< "($ATOMS_1*$SPIN_1+$ATOMS_2*$SPIN_2)+1.0")
		NELEC_ALPHA=$(bc -l <<< "($ATOMS_1*(5.0+4.0+$SPIN_1/2.0)+$ATOMS_2*(5.0+4.0+$SPIN_2/2.0))")
		NELEC_BETA=$(bc -l <<< "($ATOMS_1*(5.0+4.0-$SPIN_1/2.0)+$ATOMS_2*(5.0+4.0-$SPIN_2/2.0))")
		
		echo $SPIN_1
		echo $SPIN_2
		echo $MULTIPLICITY
		echo ${MULTIPLICITY%.*}
		echo $NELEC_ALPHA
		echo $NELEC_BETA

		sed -e "s/MULTIPLICITY_REPLACE/${MULTIPLICITY%.*}/g" \
		 -e "s/NELEC_ALPHA_REPLACE/$NELEC_ALPHA/g"  \
		 -e "s/NELEC_BETA_REPLACE/$NELEC_BETA/g"  \
		 -e "s/SPIN_1_REPLACE/$SPIN_1/g"  \
		 -e "s/SPIN_2_REPLACE/$SPIN_2/g" $template_file > $input_file

		cd $work_dir
		cp ../../$input_file .
		cp ../../$job_file .
		#cp ../../$geometry .
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


