#! /bin/bash

#output="PBE_VERSION=ORIG"
#input="PBE_VERSION=PBESOL"

input="BASIS_SET='TZV2P-MOLOPT-SR-GTH'"
output="BASIS_SET='TZVP-MOLOPT-SR-GTH'"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" submit.slurm
    cd ..
done
