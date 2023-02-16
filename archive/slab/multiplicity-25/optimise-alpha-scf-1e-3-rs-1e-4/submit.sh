#!/bin/bash
 
variable="1E-4 4E-4 8E-4 1E-3 4E-3 8E-3 1E-2 4E-2 8E-2 1E-1 4E-1 8E-1" 

input_file=input.inp
output_file=log.out 
template_file=template.inp
job_file=run.young

for ii in $variable ; do
    work_dir=folder_${ii}
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    sed -i "s/SCF_GUESS ATOMIC/SCF_GUESS RESTART/g" $input_file
    sed -i "s/EPS_SCF 1.0E-3/EPS_SCF 1.0E-4/g" $input_file
    qsub $job_file 
    cd ..
done
