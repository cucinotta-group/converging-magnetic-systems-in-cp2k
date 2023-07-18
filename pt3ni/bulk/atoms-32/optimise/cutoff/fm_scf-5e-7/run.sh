#!/bin/bash
  
param=$(seq 0 100 1000)

job_directory=search
replace=REPLACE_CUTOFF
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz

for ii in $param ; do
    work_dir=$job_directory/${ii}
    if [ -d $work_dir ] ; then
        rm -r $work_dir
    fi

    mkdir $work_dir

    sed -e "s/$replace/${ii}/g" \
        $template_file > $input_file

    cd $work_dir
    cp ../../$input_file .
    cp ../../$job_file .
    cp ../../$geometry .
    cd ../..

done

wait

for ii in $param ; do
    work_dir=$job_directory/${ii}
    cd $work_dir
    if [ -f $output_file ] ; then
        rm $output_file
    fi
    sbatch $job_file
    cd ../..
done

wait
