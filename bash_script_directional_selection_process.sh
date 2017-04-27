#! /bin/bash

n_ancestors=1 # example showing how to find organisms having novel phenotypes from a single ancestor (out of 1000)

for i in $(seq 1 $n_ancestors)
do
	# write the events.cfg file using a different ancestor organism each time
	echo $i
	echo "u begin Inject merely_viable_organisms/ancestor_"$i".org" > events_$i.cfg
	echo "u 1000:1000:end DumpTaskGrid"  >> events_$i.cfg
	echo "u 1000:1000:end DumpGenotypeGrid" >> events_$i.cfg
	echo "u 1000000 Exit" >> events_$i.cfg
	./avida -set ENVIRONMENT_FILE environment_directional_selection_process.cfg -set EVENT_FILE events_$i.cfg -set DATA_DIR data_$i -set WORLD_X 100 -set WORLD_Y 100 -set COPY_MUT_PROB 0 -set DIVIDE_INS_PROB 0 -set DIVIDE_DEL_PROB 0 -set DIVIDE_MUT_PROB 1 -set OFFSPRING_SIZE_RANGE 1 -set MIN_COPIED_LINES 0 -set MIN_EXE_LINES 0 -set REQUIRE_EXACT_COPY 1 -set STERILIZE_UNSTABLE 1 -set BASE_MERIT_METHOD 2 -set DEATH_METHOD 0

	for update in $(seq 1000 1000 1000000)
	do
		# select randomly a single sequence with a distinct phenotype every 1000 updates
		echo $update
		awk 'BEGIN {FS=" "} {for(j=1; j<=NF; j++) print $j}' "data_$i/grid_genome."$update".dat" > t_1.txt
		awk 'BEGIN {FS=" "} {for(j=1; j<=NF; j++) print $j}' "data_$i/grid_task."$update".dat" > t_2.txt
		paste t_2.txt t_1.txt > t_3.txt
		
		cat t_3.txt | sort -R --random-source=/dev/urandom | awk '!seen[$1] {print} {++seen[$1]}' | sort -n | awk -v var1=$i -v var2=$update 'BEGIN {FS=" "}{print var1, var2, $1, $2}' >> novel_sequences.txt # output as follows: ancestor_id, update, phenotype_id, sequence 
	done
	rm t_1.txt
	rm t_2.txt
	rm t_3.txt
	
	for phen in $(seq 1 511)
	do
		# select randomly a single sequence with a distinct phenotype from the evolving population
		awk -v var=$phen '{if ($3==var) print $4}' novel_sequences.txt | sort -R --random-source=/dev/urandom | head -1 | awk -v var=$phen '{print var, $1}' >> novel_seq.txt # output as follows: phenotype, sequence
	done
	rm -R data_$i
	rm events_$i.cfg
	rm novel_sequences.txt

done
