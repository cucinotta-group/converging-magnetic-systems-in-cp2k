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

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

cp2k_input=input.inp
cp2k_output=log.out

ATOMS_1=32.0
SPIN=1.8

MULTIPLICITY=$(bc -l <<< "(2.0*$ATOMS_1*$SPIN*0.5)+1.0")
NELEC_ALPHA=$(bc -l <<< "($ATOMS_1*(5.0+4.0+$SPIN/2.0))")
NELEC_BETA=$(bc -l <<< "($ATOMS_1*(5.0+4.0-$SPIN/2.0))")

echo $SPIN
echo $MULTIPLICITY
echo ${MULTIPLICITY%.*}
echo $NELEC_ALPHA
echo $NELEC_BETA

sed -i -e "s/MULTIPLICITY_REPLACE/${MULTIPLICITY%.*}/g" $cp2k_input
sed -i -e "s/NELEC_ALPHA_REPLACE/$NELEC_ALPHA/g" $cp2k_input
sed -i -e "s/NELEC_BETA_REPLACE/$NELEC_BETA/g" $cp2k_input
sed -i -e "s/SPIN_REPLACE/$SPIN/g" $cp2k_input

# CP2K 2021.1 DEV
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2022.1/cp2k-2022.1_dev-1/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out

# CP2K 2023.1 Official
#module load cp2k/cp2k-2023.1
#srun --hint=nomultithread --distribution=block:block cp2k.psmp  -i $cp2k_input > $cp2k_output

# CP2K 2023.1 Official recompiled
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out

# CP2K 2023.1 DEV
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev-2/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out
srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev-3/exe/ARCHER2/cp2k.psmp  -i $cp2k_input > $cp2k_output
