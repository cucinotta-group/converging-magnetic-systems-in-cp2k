#! /bin/bash

#output="PBE_VERSION=PBESOL"
#input="PBE_VERSION=ORIG"

input="#SBATCH --qos=short"
output="#SBATCH --qos=standard"

#input="BASIS_SET='TZV2P-MOLOPT-SR-GTH'"
#output="BASIS_SET='TZVP-MOLOPT-SR-GTH'"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" submit.slurm
    cd ..
done
