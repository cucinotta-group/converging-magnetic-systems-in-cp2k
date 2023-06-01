#!/bin/bash

# Delete all non scf-1e-2 folders
restarts=("1e-2"  "5e-3" "4e-3" "3e-3" "2e-3" "1e-3" "5e-4" "4e-4" "3e-4" "2e-4" "1e-4" "5e-5" "4e-5" "3e-5" "2e-5" "1e-5" "5e-6" "4e-6" "3e-6" "2e-6" "1e-6")
length=${#restarts[@]}
for (( i=0; i<length; i++ )); do
        if [[ "$result" ==  ${restarts[$i]} ]]; then
                rm -r scf-${restarts[i+1]}
        fi
done

# Delete all restart files
find . -name "*kp*" -type f -delete
