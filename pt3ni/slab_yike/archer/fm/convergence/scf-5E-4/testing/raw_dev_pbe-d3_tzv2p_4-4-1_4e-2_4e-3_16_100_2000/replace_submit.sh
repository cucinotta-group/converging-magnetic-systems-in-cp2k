#! /bin/bash

output="PBE_VERSION=ORIG"
input="PBE_VERSION=PBESOL"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" submit.slurm
    cd ..
done
