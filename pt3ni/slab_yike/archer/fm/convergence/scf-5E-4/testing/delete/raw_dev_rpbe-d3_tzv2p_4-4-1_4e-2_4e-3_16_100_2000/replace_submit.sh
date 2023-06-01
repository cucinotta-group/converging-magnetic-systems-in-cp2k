#! /bin/bash

input="PBE_VERSION=ORIG"
output="PBE_VERSION=REVPBE"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" submit.slurm
    cd ..
done
