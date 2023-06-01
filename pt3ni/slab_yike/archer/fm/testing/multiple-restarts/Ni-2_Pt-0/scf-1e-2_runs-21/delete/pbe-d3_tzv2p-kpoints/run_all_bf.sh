#! /bin/bash

for d in */ ; do
    echo "$d"
    cd $d
    #cp /work/e05/e05/cahart/postdoc/masters/pt3ni/yike-111/fm/Ni-2_Pt-0/multiple-restarts/scf-1e-2_runs-5/scripts/refresh.sh .
    #chmod u+x refresh.sh
    #./refresh.sh
    cd scf-1E-2
    rm slurm-*; sbatch submit.slurm
    cd ..
    cd ..
done
