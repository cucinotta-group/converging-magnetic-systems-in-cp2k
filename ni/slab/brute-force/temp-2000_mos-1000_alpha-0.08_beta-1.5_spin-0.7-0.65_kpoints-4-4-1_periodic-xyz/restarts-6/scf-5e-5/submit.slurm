#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cray-fftw

export OMP_NUM_THREADS=1

cp2k_input=cp2k.inp
cp2k_output=log.out
srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev-3/exe/ARCHER2/cp2k.psmp   -i $cp2k_input > $cp2k_output

result=${PWD##*/}
echo "PWD" $result

restarts=("scf-1e-4" "scf-5e-5" "scf-1e-5" "scf-5e-6" "scf-1e-6" "scf-5e-7" "scf-1e-7" )
replace=("EPS_SCF     1E-4" "EPS_SCF     5E-5" "EPS_SCF     1E-5" "EPS_SCF     5E-6" "EPS_SCF     1E-6" "EPS_SCF     5E-7" "EPS_SCF     1E-7")

length=${#restarts[@]}
echo "Number of runs" $length

for (( i=0; i<length; i++ )); do
	if [[ "$result" ==  ${restarts[$i]} ]]; then

		echo "Submitting job" ${restarts[$i+1]}
		cd ..

		cp -r ${restarts[i]} ${restarts[i+1]}
		cd ${restarts[i+1]}
		sed -i -e "s/${replace[i]}/${replace[i+1]}/g" $cp2k_input
		rm log.out; rm Ni*;  rm slurm-*
		cp ../${restarts[i]}/*.kp .
		sbatch submit.slurm	

	fi
done
