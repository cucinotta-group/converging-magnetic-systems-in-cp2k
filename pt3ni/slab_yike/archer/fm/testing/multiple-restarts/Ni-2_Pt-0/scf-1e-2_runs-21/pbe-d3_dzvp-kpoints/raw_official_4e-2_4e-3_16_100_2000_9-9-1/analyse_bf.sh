#!/bin/bash

restarts=("1E-2"  "5E-3" "4E-3" "3E-3" "2E-3" "1E-3" "5E-4" "4E-4" "3E-4" "2E-4" "1E-4" "5E-5" "4E-5" "3E-5" "2E-5" "1E-5" "5E-6" "4E-6" "3E-6" "2E-6" "1E-6")

length=${#restarts[@]}
echo "Number of runs" $length

output_file=log.out
data_output_1=data.out

rm $data_output_1

printf "%s %s %s %s %s" "Folder" "Energy" "SCF" "Time" "IASD" >> $data_output_1
printf "\n" >> $data_output_1

for (( i=0; i<length; i++ )); do

		work_dir=scf-${restarts[$i]}

                en_H=$(grep 'Total F' $work_dir/$output_file | awk '{print $9}')
                time=$(grep 'CP2K   ' $work_dir/$output_file  | awk '{print $6}')
                scf=$(grep 'scf_env_do_scf_inner_loop' $work_dir/$output_file | awk '{print $2}')
                iasd=$(grep 'Integrated absolute' $work_dir/$output_file | awk '{print $6}')

                printf "%s %f %d %f %f" ${restarts[$i]}  $en_H $scf $time $iasd >> $data_output_1
                printf "\n" >> $data_output_1

done

scf_sum=$(grep 'scf_env_do_scf_inner_loop'   */log.out  | awk '{ SUM += $3} END { print SUM }')
time_sum=$(grep 'CP2K   '   */log.out  | awk '{ SUM += $7} END { print SUM }')

printf "\n" >> $data_output_1
printf "%s %i" "Total SCF" $scf_sum >> $data_output_1
printf "\n" >> $data_output_1
printf "%s %f" "Total time" $time_sum >> $data_output_1
