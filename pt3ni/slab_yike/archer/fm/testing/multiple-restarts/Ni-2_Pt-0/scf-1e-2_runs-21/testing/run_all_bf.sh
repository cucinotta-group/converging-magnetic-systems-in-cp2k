#! /bin/bash

for d in */ ; do
    echo "$d"
    cd $d
    cp ../scripts/refresh.sh .
    chmod u+x refresh.sh
    ./refresh.sh
    cd scf-1E-2
    rm slurm-*; sbatch submit.slurm
    cd ..
    cd ..
done
