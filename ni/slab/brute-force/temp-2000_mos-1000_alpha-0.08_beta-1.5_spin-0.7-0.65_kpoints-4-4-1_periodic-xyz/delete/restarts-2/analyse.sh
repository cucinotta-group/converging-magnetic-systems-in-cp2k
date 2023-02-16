#!/bin/bash
  
param_1="scf-1e-3 scf-5e-4 scf-3e-4 scf-2e-4 scf-1e-4 scf-5e-5 scf-1e-5 scf-5e-6 scf-1e-6 scf-5e-7 scf-1e-7"

job_directory=search
input_file=cp2k.inp
output_file=log.out
template_file=template.inp
job_file=submit.slurm
geometry=input.xyz
data_output_1=data.out

rm $data_output_1

printf "%s %s %s %s %s" "Folder" "Energy" "SCF" "Time" "IASD" >> $data_output_1
printf "\n" >> $data_output_1

for ii in $param_1 ; do
                work_dir=${ii}

                en_H=$(grep 'Total F' $work_dir/$output_file | awk '{print $9}')
                time=$(grep 'CP2K   ' $work_dir/$output_file  | awk '{print $6}')
                scf=$(grep 'scf_env_do_scf_inner_loop' $work_dir/$output_file | awk '{print $2}')
                iasd=$(grep 'Integrated absolute' $work_dir/$output_file | awk '{print $6}')

                printf "%s %f %d %f %f" $ii $en_H $scf $time $iasd >> $data_output_1
                printf "\n" >> $data_output_1
done

scf_sum=$(grep 'scf_env_do_scf_inner_loop'   */log.out  | awk '{ SUM += $3} END { print SUM }')
time_sum=$(grep 'CP2K   '   */log.out  | awk '{ SUM += $7} END { print SUM }')

printf "\n" >> $data_output_1
printf "%s %i" "Total SCF" $scf_sum >> $data_output_1
printf "\n" >> $data_output_1
printf "%s %f" "Total time" $time_sum >> $data_output_1

