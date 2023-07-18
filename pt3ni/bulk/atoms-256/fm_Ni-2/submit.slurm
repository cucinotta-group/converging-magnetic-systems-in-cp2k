#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH --nodes=4
#SBATCH --tasks-per-node=128
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --account=e05-surfin-clo 
#SBATCH --partition=standard
#SBATCH --qos=standard

module load PrgEnv-gnu
module load cpe/21.09
module load mkl
module load cray-fftw

# Sergey CP2k+SMEAGOL
#cp2k=/work/e05/e05/cahart/smeagol/smgl/cp2k-private-sergey-2/exe/local/cp2k.psmp
cp2k=/work/e05/e05/cahart/cp2k/cp2k-2023.1-updated/cp2k-2023.1-chris/exe/ARCHER2/cp2k.popt

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
cp input/* .

srun --hint=nomultithread --distribution=block:block $cp2k -i cp2k.inp -o log.out
