#! /bin/bash

output="EPS_SCF 5E-4"
input="EPS_SCF 1E-3"

for d in */ ; do
    echo "$d"
    cd $d
    sed -i -e "s/${input}/${output}/g" input/input.inp
    cd ..
done
