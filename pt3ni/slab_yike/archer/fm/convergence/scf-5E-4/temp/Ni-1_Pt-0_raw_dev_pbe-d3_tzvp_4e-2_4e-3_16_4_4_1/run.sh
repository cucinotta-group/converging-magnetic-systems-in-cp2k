#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing

#param_1="300 400 600 800 1000 1200 1400 1600 1800 200 3000"
param_1="2000"

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

    sed -i -e "s/ELECTRONIC_TEMPERATURE     2000/ELECTRONIC_TEMPERATURE     ${ii}/g" input/$input_file
    #sed -i -e "s/CUTOFF=600/CUTOFF=${ii}/g" $job_file
    
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
