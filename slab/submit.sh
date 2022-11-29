#!/bin/bash

for d in */ ; do
        echo "$d"
        cd $d
	cp ../run.young .
        rm log.out Ni* test*  Bulk* 
	qsub run.young
        cd ..
done
