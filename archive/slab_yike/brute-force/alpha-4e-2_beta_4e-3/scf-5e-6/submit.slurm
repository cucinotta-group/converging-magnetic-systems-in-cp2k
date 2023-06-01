#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cray-fftw

export OMP_NUM_THREADS=1

srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2022.1/cp2k-2022.1_dev-1/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out

result=${PWD##*/}
echo "PWD" $result

restarts=("scf-1e-2"  "scf-5e-3" "scf-4e-3" "scf-3e-3" "scf-2e-3" "scf-1e-3" "scf-5e-4" "scf-4e-4" "scf-3e-4" "scf-2e-4" "scf-1e-4" "scf-5e-5" "scf-4e-5" "scf-3e-5" "scf-2e-5" "scf-1e-5" "scf-5e-6" "scf-4e-6" "scf-3e-6" "scf-2e-6" "scf-1e-6" "scf-5e-7" "scf-4e-7" "scf-3e-7"  "scf-2e-7"  "scf-1e-7")
replace=("EPS_SCF     1E-2" "EPS_SCF     5E-3" "EPS_SCF     4E-3" "EPS_SCF     3E-3" "EPS_SCF     2E-3"  "EPS_SCF     1E-3" "EPS_SCF     5E-4" "EPS_SCF     4E-4" "EPS_SCF     3E-4" "EPS_SCF     2E-4" "EPS_SCF     1E-4" "EPS_SCF     5E-5" "EPS_SCF     4E-5" "EPS_SCF     3E-5" "EPS_SCF     2E-5" "EPS_SCF     1E-5" "EPS_SCF     5E-6" "EPS_SCF     4E-6" "EPS_SCF     3E-6" "EPS_SCF     2E-6"   "EPS_SCF     1E-6" "EPS_SCF     5E-7" "EPS_SCF     4E-7" "EPS_SCF     3E-7" "EPS_SCF     2E-7" "EPS_SCF     1E-7")

length=${#restarts[@]}
echo "Number of runs" $length

for (( i=0; i<length; i++ )); do
	if [[ "$result" ==  ${restarts[$i]} ]]; then

		echo "Submitting job" ${restarts[$i+1]}
		cd ..

		cp -r ${restarts[i]} ${restarts[i+1]}
		cd ${restarts[i+1]}
		sed -i -e "s/${replace[i]}/${replace[i+1]}/g" cp2k.inp
		rm log.out; rm Pt3Ni*; rm slurm-*
		cp ../${restarts[i]}/Pt3Ni-RESTART.kp .
		sbatch submit.slurm	

	fi
done
