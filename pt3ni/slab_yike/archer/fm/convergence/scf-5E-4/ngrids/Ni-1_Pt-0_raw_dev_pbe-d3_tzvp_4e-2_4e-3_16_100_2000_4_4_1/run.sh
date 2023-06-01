#!/bin/bash

# 2D grid search bash script
# Max number of ARCHER2 jobs is 64 queueing

param_1="3 4 5 6"

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

    sed -i -e "s/NGRIDS  4/NGRIDS ${ii}/g" input/$input_file
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
