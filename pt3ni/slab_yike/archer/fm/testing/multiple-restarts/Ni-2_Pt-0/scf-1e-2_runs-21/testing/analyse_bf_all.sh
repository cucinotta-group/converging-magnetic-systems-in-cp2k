#! /bin/bash

for d in raw*/ ; do
    echo "$d"
    cd $d
    cp ../scripts/analyse_bf.sh .
    chmod u+x analyse_bf.sh
    ./analyse_bf.sh
    cd ..
done

grep 'Total SCF' */data.out
