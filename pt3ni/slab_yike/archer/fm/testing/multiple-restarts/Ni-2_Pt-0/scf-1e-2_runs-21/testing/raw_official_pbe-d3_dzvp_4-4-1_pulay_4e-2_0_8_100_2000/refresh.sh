#!/bin/bash

# Delete all folders apart from first
restarts=("1E-2"  "5E-3" "4E-3" "3E-3" "2E-3" "1E-3" "5E-4" "4E-4" "3E-4" "2E-4" "1E-4" "5E-5" "4E-5" "3E-5" "2E-5" "1E-5" "5E-6" "4E-6" "3E-6" "2E-6" "1E-6")
length=${#restarts[@]}
for (( i=0; i<length; i++ )); do
                rm -r scf-${restarts[i+1]}
done

# Delete all restart files
find . -name "*kp*" -type f -delete
