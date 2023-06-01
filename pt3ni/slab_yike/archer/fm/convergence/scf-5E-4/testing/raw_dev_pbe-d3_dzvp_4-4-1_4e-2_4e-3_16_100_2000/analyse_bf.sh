#!/bin/bash

output_file=log.out
data_output_1=data.out

rm $data_output_1

printf "%s %s %s %s %s" "Folder" "Energy" "SCF" "Time" "IASD" >> $data_output_1
printf "\n" >> $data_output_1

for d in */ ; do

		work_dir=$d
		echo $work_dir

                en_H=$(grep 'Total F' $work_dir/$output_file | awk '{print $9}')
                time=$(grep 'CP2K   ' $work_dir/$output_file  | awk '{print $6}')
                scf=$(grep 'scf_env_do_scf_inner_loop' $work_dir/$output_file | awk '{print $2}')
                iasd=$(grep 'Integrated absolute' $work_dir/$output_file | awk '{print $6}')

                #echo $en_H
		#echo $time
		#echo $scf
		#echo $iasd
		
		printf "%s %f %d %f %f" $work_dir  $en_H $scf $time $iasd >> $data_output_1
                printf "\n" >> $data_output_1

done

