#!/bin/bash

for d in */ ; do
        echo "$d"
        cd $d
	#cp ../run.slurm .
	sbatch run.slurm
        cd ..
done
