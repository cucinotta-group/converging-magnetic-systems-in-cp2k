#! /bin/bash

dqt='"'

#input="${dqt}1E-2${dqt} ${dqt}1E-3${dqt} ${dqt}1E-4${dqt}  ${dqt}1E-5${dqt} ${dqt}1E-6${dqt}"
input="${dqt}1E-2${dqt} ${dqt}1E-3${dqt} ${dqt}1E-4${dqt} ${dqt}5E-5${dqt} ${dqt}1E-5${dqt} ${dqt}5E-6${dqt} ${dqt}1E-6${dqt}"
output="${dqt}1E-2${dqt} ${dqt}5E-3${dqt} ${dqt}4E-3${dqt} ${dqt}3E-3${dqt} ${dqt}2E-3${dqt} ${dqt}1E-3${dqt} ${dqt}5E-4${dqt} ${dqt}4E-4${dqt} ${dqt}3E-4${dqt} ${dqt}2E-4${dqt} ${dqt}1E-4${dqt} ${dqt}5E-5${dqt} ${dqt}4E-5${dqt} ${dqt}3E-5${dqt} ${dqt}2E-5${dqt} ${dqt}1E-5${dqt} ${dqt}5E-6${dqt} ${dqt}4E-6${dqt} ${dqt}3E-6${dqt} ${dqt}2E-6${dqt} ${dqt}1E-6${dqt}"

#input="#SBATCH --time=01:00:00"
#output="#SBATCH --time=02:00:00"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" scf-1E-2/submit.slurm
    cd ..
done
