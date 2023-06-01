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

ATOMS_1=45.0
ATOMS_2=15.0

SPIN_1=0.0
SPIN_2=2.0

MULTIPLICITY=$(bc -l <<< "($ATOMS_1*$SPIN_1+$ATOMS_2*$SPIN_2)+1.0")
NELEC_ALPHA=$(bc -l <<< "($ATOMS_1*(5.0+4.0+$SPIN_1/2.0)+$ATOMS_2*(5.0+4.0+$SPIN_2/2.0))")
NELEC_BETA=$(bc -l <<< "($ATOMS_1*(5.0+4.0-$SPIN_1/2.0)+$ATOMS_2*(5.0+4.0-$SPIN_2/2.0))")

echo $SPIN_1
echo $SPIN_2
echo $MULTIPLICITY
echo ${MULTIPLICITY%.*}
echo $NELEC_ALPHA
echo $NELEC_BETA

sed -i -e "s/MULTIPLICITY_REPLACE/${MULTIPLICITY%.*}/g" $cp2k_input
sed -i -e "s/NELEC_ALPHA_REPLACE/$NELEC_ALPHA/g" $cp2k_input
sed -i -e "s/NELEC_BETA_REPLACE/$NELEC_BETA/g" $cp2k_input
sed -i -e "s/SPIN_1_REPLACE/$SPIN_1/g" $cp2k_input
sed -i -e "s/SPIN_2_REPLACE/$SPIN_2/g" $cp2k_input

ALPHA=4E-2
BETA=4E-3
KPOINTS=4
BASIS_SET='TZVP-MOLOPT-SR-GTH'
sed -i -e "s/ALPHA_REPLACE/$ALPHA/g" $cp2k_input
sed -i -e "s/BETA_REPLACE/$BETA/g" $cp2k_input
sed -i -e "s/KPOINTS_REPLACE/$KPOINTS/g" $cp2k_input
sed -i -e "s/BASIS_SET_REPLACE/$BASIS_SET/g" $cp2k_input
export OMP_NUM_THREADS=1

# CP2K 2023.1 Official
module load cp2k/cp2k-2023.1
cp2k=cp2k.psmp  

# CP2K 2023.1 Official recompiled
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out

# CP2K 2023.1 DEV
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev-2/exe/ARCHER2/cp2k.popt  -i cp2k.inp > log.out
#srun --hint=nomultithread --distribution=block:block /work/e05/e05/cahart/cp2k/cp2k-2023.1/cp2k-2023.1-dev-3/exe/ARCHER2/cp2k.psmp  -i $cp2k_input > $cp2k_output

srun --hint=nomultithread --distribution=block:block $cp2k  -i $cp2k_input > $cp2k_output

current_folder=${PWD##*/}
result=${current_folder: -4}
echo "PWD" $result

restarts=("1E-2" "5E-3" "4E-3" "3E-3" "2E-3" "1E-3" "5E-4" "4E-4" "3E-4" "2E-4" "1E-4" "5E-5" "4E-5" "3E-5" "2E-5" "1E-5" "5E-6" "4E-6" "3E-6" "2E-6" "1E-6")

length=${#restarts[@]}
loops=length-1
echo "Number of runs" $length

for (( i=0; i<loops; i++ )); do
	if [[ "$result" ==  ${restarts[$i]} ]]; then

		echo "Submitting job" ${restarts[$i+1]}
		cd ..

		cp -r scf-${restarts[i]} scf-${restarts[i+1]}
		cd scf-${restarts[i+1]}
		sed -i -e "s/EPS_SCF ${restarts[i]}/EPS_SCF ${restarts[i+1]}/g" input/input.inp
		rm log.out; rm Pt3Ni*; rm slurm-*
		cp ../scf-${restarts[i]}/Pt3Ni-RESTART.kp input/
		sbatch submit.slurm	

	fi
done
