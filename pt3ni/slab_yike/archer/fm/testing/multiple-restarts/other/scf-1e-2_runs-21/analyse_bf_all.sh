#! /bin/bash

for d in Ni*/ ; do
    echo "$d"
    cd $d
    cp ../analyse_bf.sh .
    chmod u+x analyse_bf.sh
    ./analyse_bf.sh
    cd ..
done

grep 'Total SCF' */data.out
