#!/usr/bin/env bash

#SBATCH -n 96
#SBATCH --exclusive 
#SBATCH -C  "scarf21"
#SBATCH -t 24:00:00

module purge
module load GCC/10.3.0 OpenMPI/4.1.1-GCC-10.3.0 OpenBLAS/0.3.15-GCC-10.3.0

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

cp2k_input=cp2k.inp
cp2k_output=log.out

EPS_SCF="5E-3 5E-4 2E-4 1E-4 5e-5 1E-5 5e-6"
array=($EPS_SCF)
first_element=${array[0]}
last_element=${array[${#array[@]}-1]}
length=${#array[@]}
echo $EPS_SCF
echo $first_element
echo $last_element
echo $length

sed -i -e "s/EPS_SCF_INNER_REPLACE/$first_element/g" $cp2k_input
sed -i -e "s/EPS_SCF_OUTER_REPLACE/$last_element/g" $cp2k_input
sed -i -e "s/MAX_SCF_OUTER_REPLACE/$length/g" $cp2k_input
sed -i -e "s/EPS_SCF_ARRAY_REPLACE/$EPS_SCF/g" $cp2k_input

ATOMS_1_1=12.0
ATOMS_1_2=6.0
ATOMS_1_3=9.0
ATOMS_1_4=6.0
ATOMS_1_5=12.0

ATOMS_2_1=6.0
ATOMS_2_2=3.0
ATOMS_2_3=6.0

SPIN_1_1=0.0
SPIN_1_2=0.0
SPIN_1_3=0.0
SPIN_1_4=0.0
SPIN_1_5=0.0

SPIN_2_1=1.0
SPIN_2_2=1.0
SPIN_2_3=1.0

MULTIPLICITY=$(bc -l <<< "($ATOMS_1_1*$SPIN_1_1+$ATOMS_1_2*$SPIN_1_2+$ATOMS_1_3*$SPIN_1_3+$ATOMS_1_4*$SPIN_1_4+$ATOMS_1_5*$SPIN_1_5+$ATOMS_2_1*$SPIN_2_1+$ATOMS_2_2*$SPIN_2_2+$ATOMS_2_3*$SPIN_2_3)+1.0")

NELEC_ALPHA=$(bc -l <<< "($ATOMS_1_1*(5.0+4.0+$SPIN_1_1/2.0)+$ATOMS_1_2*(5.0+4.0+$SPIN_1_2/2.0)+$ATOMS_1_3*(5.0+4.0+$SPIN_1_3/2.0)+$ATOMS_1_4*(5.0+4.0+$SPIN_1_4/2.0)+$ATOMS_1_5*(5.0+4.0+$SPIN_1_5/2.0)+$ATOMS_2_1*(5.0+4.0+$SPIN_2_1/2.0)+$ATOMS_2_2*(5.0+4.0+$SPIN_2_2/2.0)+$ATOMS_2_3*(5.0+4.0+$SPIN_2_3/2.0))")

NELEC_BETA=$(bc -l <<< "($ATOMS_1_1*(5.0+4.0-$SPIN_1_1/2.0)+$ATOMS_1_2*(5.0+4.0-$SPIN_1_2/2.0)+$ATOMS_1_3*(5.0+4.0-$SPIN_1_3/2.0)+$ATOMS_1_4*(5.0+4.0-$SPIN_1_4/2.0)+$ATOMS_1_5*(5.0+4.0-$SPIN_1_5/2.0)+$ATOMS_2_1*(5.0+4.0-$SPIN_2_1/2.0)+$ATOMS_2_2*(5.0+4.0-$SPIN_2_2/2.0)+$ATOMS_2_3*(5.0+4.0-$SPIN_2_3/2.0))")

echo $SPIN_1
echo $SPIN_2
echo $MULTIPLICITY
echo ${MULTIPLICITY%.*}
echo $NELEC_ALPHA
echo $NELEC_BETA

sed -i -e "s/MULTIPLICITY_REPLACE/${MULTIPLICITY%.*}/g" $cp2k_input
sed -i -e "s/NELEC_ALPHA_REPLACE/$NELEC_ALPHA/g" $cp2k_input
sed -i -e "s/NELEC_BETA_REPLACE/$NELEC_BETA/g" $cp2k_input
sed -i -e "s/SPIN_1_1_REPLACE/$SPIN_1_1/g" $cp2k_input
sed -i -e "s/SPIN_1_2_REPLACE/$SPIN_1_2/g" $cp2k_input
sed -i -e "s/SPIN_1_3_REPLACE/$SPIN_1_3/g" $cp2k_input
sed -i -e "s/SPIN_1_4_REPLACE/$SPIN_1_4/g" $cp2k_input
sed -i -e "s/SPIN_1_5_REPLACE/$SPIN_1_5/g" $cp2k_input
sed -i -e "s/SPIN_2_1_REPLACE/$SPIN_2_1/g" $cp2k_input
sed -i -e "s/SPIN_2_2_REPLACE/$SPIN_2_2/g" $cp2k_input
sed -i -e "s/SPIN_2_3_REPLACE/$SPIN_2_3/g" $cp2k_input

ALPHA=4E-2
BETA=4E-3
NBUFFER=16
KPOINTS=8
PBE_VERSION=ORIG
BASIS_SET='TZVP-MOLOPT-SR-GTH'
sed -i -e "s/NBUFFER_REPLACE/$NBUFFER/g" $cp2k_input
sed -i -e "s/PBE_REPLACE/$PBE_VERSION/g" $cp2k_input
sed -i -e "s/ALPHA_REPLACE/$ALPHA/g" $cp2k_input
sed -i -e "s/BETA_REPLACE/$BETA/g" $cp2k_input
sed -i -e "s/KPOINTS_REPLACE/$KPOINTS/g" $cp2k_input
sed -i -e "s/BASIS_SET_REPLACE/$BASIS_SET/g" $cp2k_input
export OMP_NUM_THREADS=1

# Chris CP2K
#cp2k=/work4/scd/scarf1157/work/code/cp2k/scarf21/cp2k-private-chris-3/exe/local/cp2k.psmp
#cp2k=/work4/scd/scarf1157/work/code/cp2k/scarf21/cp2k-private-chris-4/exe/local/cp2k.psmp
#cp2k=/work4/cse/scarf1157/work/code/cp2k/scarf21/nelectron-specify_outer-scf2/exe/local/cp2k.psmp
cp2k=/work4/cse/scarf1157/work/code/cp2k/scarf21/nelectron-specify_outer-scf3/exe/local/cp2k.psmp

mpirun $cp2k  -i $cp2k_input > $cp2k_output

