#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=4
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=short

module load cp2k

# Official
#cp2k=/work/y07/shared/apps/core/cp2k/cp2k-2023.1/exe/ARCHER2/cp2k.popt

# Chris
cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1-updated/cp2k-2023.1-chris/exe/ARCHER2/cp2k.popt
cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1-updated/cp2k-2023.1-chris-2/exe/ARCHER2/cp2k.popt

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
cp input/* .

srun --hint=nomultithread --distribution=block:block $cp2k -i cp2k.inp -o log.out


directory=${PWD##*/}
input=input/cp2k.inp
restart_file=Pt3Ni-RESTART.wfn

echo "PWD" $result

EPS_SCF_ARRAY=("1E-1" "5E-2" "1E-2" "5E-3" "4E-3" "3E-3" "2E-3" "1E-3" "9E-4" "8E-4" "7E-4" "6E-4" "5E-4" "4E-4" "3E-4" "2E-4" "1E-4" "9E-5" "8E-5" "7E-5" "6E-5" "5E-5" "4E-5" "3E-5" "2E-5" "1E-5" "5E-6")

length=${#EPS_SCF_ARRAY[@]}
echo "Number of runs" $length

for (( i=0; i<length; i++ )); do
        if [[ "$directory" ==  ${EPS_SCF_ARRAY[$i]} ]]; then

                echo "Submitting job" ${EPS_SCF_ARRAY[$i+1]}
                cd ..

                cp -r ${EPS_SCF_ARRAY[$i]} ${EPS_SCF_ARRAY[$i+1]}
                cd ${EPS_SCF_ARRAY[$i+1]}

                sed -i -e "s/EPS_SCF ${EPS_SCF_ARRAY[$i]}/EPS_SCF ${EPS_SCF_ARRAY[$i+1]}/g" $input
                cp ../${EPS_SCF_ARRAY[$i]}/$restart_file input/
                rm slurm-*; sbatch submit.slurm

        fi
done


