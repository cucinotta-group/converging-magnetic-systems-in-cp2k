#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=1
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=00:02:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cray-fftw

export OMP_NUM_THREADS=1

#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2022.1/cp2k-2022.1_dev-1/exe/ARCHER2/cp2k.pdbg  -i cp2k.inp > log.out
srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2022.1/cp2k-2022.1_dev-1/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out
