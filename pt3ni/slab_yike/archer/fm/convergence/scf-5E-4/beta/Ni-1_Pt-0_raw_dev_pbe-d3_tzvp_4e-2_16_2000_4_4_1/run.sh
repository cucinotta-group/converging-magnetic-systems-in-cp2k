#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing

param_1="4e-5 4e-4 4e-3 4e-2 4e-1 5e-1 9e-1 1.0 1.5 2.0 5.0 10.0"

job_directory=search
input_file=cp2k.inp
output_file=log.out
job_file=submit.slurm
geometry=struct.xyz

for ii in $param_1 ; do
    work_dir=$job_directory/${ii}
    echo $work_dir
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir

    cd $work_dir
    cp -r ../../input .
    cp ../../$job_file .

    #sed -i -e "s/ADDED_MOS 100/ADDED_MOS ${ii}/g" input/$input_file
    sed -i -e "s/BETA=4E-3/BETA=${ii}/g" $job_file
    
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
