#! /bin/bash

#input="PBE_VERSION=PBESOL"
#output="PBE_VERSION=REVPBE"

#input="#SBATCH --qos=short"
#output="#SBATCH --qos=standard"

#input="BASIS_SET='DZVP-MOLOPT-SR-GTH'"
#output="BASIS_SET='TZVP-MOLOPT-SR-GTH'"

#input="#SBATCH -t 00:20:00"
#output="#SBATCH -t 24:00:00"

input="#SBATCH -n 24"
output="#SBATCH -n 96"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" submit.slurm
    cd ..
done