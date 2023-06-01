#! /bin/bash

for d in raw*/ ; do
    echo "$d"
    cd $d
    cp /work/e05/e05/cahart/postdoc/masters/pt3ni/yike-111/fm/Ni-2_Pt-0/multiple-restarts/scf-1e-2_runs-21/scripts/analyse_bf.sh .
    chmod u+x analyse_bf.sh
    ./analyse_bf.sh
    cd ..
done

grep 'Total SCF' */data.out
