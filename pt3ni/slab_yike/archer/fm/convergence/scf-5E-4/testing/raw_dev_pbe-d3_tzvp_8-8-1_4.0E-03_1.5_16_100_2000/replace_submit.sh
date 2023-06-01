#! /bin/bash

#output="PBE_VERSION=ORIG"
#input="PBE_VERSION=PBESOL"

#input="KPOINTS=4"
#output="KPOINTS=8"

#input="ALPHA=4E-2"
#output="ALPHA=4E-3"

#input="BETA=4E-3"
#output="BETA=1.5"

input="#SBATCH --qos=short"
output="#SBATCH --qos=taskfarm"

#input="BASIS_SET='TZV2P-MOLOPT-SR-GTH'"
#output="BASIS_SET='TZVP-MOLOPT-SR-GTH'"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" submit.slurm
    cd ..
done
