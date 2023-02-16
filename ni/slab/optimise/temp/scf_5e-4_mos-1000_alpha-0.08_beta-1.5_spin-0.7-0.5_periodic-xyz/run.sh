#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing, therefore 8x8 grid

param_1="10 50 100 200 300 400 500 600 700 800 900 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000"

job_directory=search
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz

ATOMS_1=16.0
ATOMS_2=16.0
SPIN_1=0.5
SPIN_2=0.7
MULTIPLICITY=$(bc -l <<< "($ATOMS_1*$SPIN_1+$ATOMS_2*$SPIN_2)+1.0")
NELEC_ALPHA=$(bc -l <<< "($ATOMS_1*(5.0+4.0+$SPIN_1/2.0)+$ATOMS_2*(5.0+4.0+$SPIN_2/2.0))")
NELEC_BETA=$(bc -l <<< "($ATOMS_1*(5.0+4.0-$SPIN_1/2.0)+$ATOMS_2*(5.0+4.0-$SPIN_2/2.0))")
KPOINTS=4
MOS=1000

for ii in $param_1 ; do
    work_dir=$job_directory/${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir

    sed          -e "s/MULTIPLICITY_REPLACE/${MULTIPLICITY%.*}/g" \
                 -e "s/NELEC_ALPHA_REPLACE/$NELEC_ALPHA/g"  \
                 -e "s/NELEC_BETA_REPLACE/$NELEC_BETA/g"  \
                 -e "s/SPIN_1_REPLACE/$SPIN_1/g"  \
                 -e "s/SPIN_2_REPLACE/$SPIN_2/g" \
		 -e "s/KPOINTS_REPLACE/$KPOINTS/g" \
		 -e "s/ADDED_MOS_REPLACE/$MOS/g"  \
   		 -e "s/TEMPERATURE_REPLACE/${ii}/g"  $template_file > $input_file

    cd $work_dir
    cp ../../$input_file .
    cp ../../$job_file .
    #cp ../../$geometry .
    cd ../..

done

wait

for ii in $param_1 ; do
    work_dir=$job_directory/${ii}
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    sbatch $job_file
    cd ../..
done

wait
