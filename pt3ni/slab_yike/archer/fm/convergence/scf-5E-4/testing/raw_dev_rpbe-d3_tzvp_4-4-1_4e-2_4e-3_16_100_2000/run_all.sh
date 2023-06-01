#! /bin/bash

for d in */ ; do
    echo "$d"
    cd $d
    rm slurm-*; sbatch submit.slurm
    cd ..
done
