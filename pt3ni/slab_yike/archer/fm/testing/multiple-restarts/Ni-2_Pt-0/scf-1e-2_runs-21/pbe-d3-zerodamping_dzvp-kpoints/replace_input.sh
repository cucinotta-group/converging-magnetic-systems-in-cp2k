#! /bin/bash

input="TYPE  DFTD3(BJ)"
output="TYPE  DFTD3"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" scf-1E-2/input/input.inp
    cd ..
done
