#!/bin/bash

letters=( a b c d e f g h i j k l m n o p q r s t u v w x y z ) #instruction set (26 letters)

ancestor_seq="nfyfryufmrjsyxbkzbwurqoexmwrcbdqbwhcowrbzvucccaofburvpfyvrovxgkogtujcihhtsopjcjiyarocchmvfrlqshbfguu"
ancestor_phen="32" # specify the phenotype of the genotype: in this example, the organism performs only function ANDN

bin_number=$(echo "obase=2;$ancestor_phen" | bc) # convert decimal to binary
task_list=$(printf "%09d\n" $bin_number | rev) # add leading zeros and revert the order to match the "task_list" output format	

for z in $(seq 0 $((${#ancestor_seq}-1))) # convert the string ancestor into an array named sequence
do
	sequence[$z]=${ancestor_seq:$z:1}
done # for z

mut_steps=0
max_hamming=0
while [ "$mut_steps" -lt 1000 ] # 1000 double mutations in a row without increasing distance 
do
	echo $max_hamming $mut_steps
	viable_same_phenotype=""
	while [ -z "$viable_same_phenotype" ] # do while the variable is empty
	do
		i=$(shuf -i 0-$((${#ancestor_seq}-1)) -n 1) # first random position in the genome
		j=$(shuf -i 0-$((${#ancestor_seq}-1)) -n 1) # second random position in the genome
		while [ "$i" == "$j" ]
		do
			i=$(shuf -i 0-$((${#ancestor_seq}-1)) -n 1) # first random position in the genome
			j=$(shuf -i 0-$((${#ancestor_seq}-1)) -n 1) # second random position in the genome
		done
		x=$(shuf -i 0-$((${#letters[*]}-1)) -n 1) # first random letter from the alphabet
		while [ "${sequence[$i]}" == "${letters[$x]}" ]
		do
	       		x=$(shuf -i 0-$((${#letters[*]}-1)) -n 1) # first random letter from the alphabet
		done
		letter_x=${letters[$x]} # first mutation
		y=$(shuf -i 0-$((${#letters[*]}-1)) -n 1) # second random letter from the alphabet
		while [ "${sequence[$j]}" == "${letters[$y]}" ]
		do
			y=$(shuf -i 0-$((${#letters[*]}-1)) -n 1) # second random letter from the alphabet
		done
		letter_y=${letters[$y]} # second mutation
		letter_x_0=${sequence[$i]} # save previous letter first mutation to restore the ancestor
		letter_y_0=${sequence[$j]} # save previous letter second mutation to restore the ancestor
		sequence[$i]=$letter_x # replace the letter by the first mutation
		sequence[$j]=$letter_y # replace the letter by the second mutation
		genome=$(echo ${sequence[*]} | sed 's/ //g')
		echo "PURGE_BATCH" > analyze.cfg
		echo "LOAD_SEQUENCE" $genome >> analyze.cfg # print the new sequence
		echo "RECALCULATE" >> analyze.cfg
		echo "DETAIL output.txt viable task_list" >> analyze.cfg
		# run avida in analyze mode
		./avida -a -set ENVIRONMENT_FILE environment_purifying_selection_process.cfg -set EVENT_FILE events.cfg -set WORLD_X 100 -set WORLD_Y 100 -set COPY_MUT_PROB 0 -set DIVIDE_INS_PROB 0 -set DIVIDE_DEL_PROB 0 -set DIVIDE_MUT_PROB 0 -set OFFSPRING_SIZE_RANGE 1 -set MIN_COPIED_LINES 0 -set MIN_EXE_LINES 0 -set REQUIRE_EXACT_COPY 1 -set STERILIZE_UNSTABLE 1 -set BASE_MERIT_METHOD 2 -set DEATH_METHOD 0 > /dev/null 2>&1
		viable_same_phenotype=$(awk -v var=$task_list '{if(NR==8 && $1==1 && $2==var) print "TRUE"}' data/output.txt)
		if [ -z "$viable_same_phenotype" ]
		then
			sequence[$i]=$letter_x_0  # revert the first mutation
			sequence[$j]=$letter_y_0  # revert the second mutation
		fi
	done # while not viable or distinct phenotype

	hamming=0
	for z in $(seq 0 $((${#ancestor_seq}-1))) # compute Hamming distance
	do
		if [ "${genome:$z:1}" != "${ancestor_seq:$z:1}" ]; then
			hamming=$(($hamming+1))
		fi
	done
	if [ "$hamming" -gt "$max_hamming" ]; then # distance has increased
		max_hamming=$hamming
		mut_steps=0
	else
		mut_steps=$(($mut_steps+1))			
	fi

done # while hamming

echo $ancestor_phen $ancestor_seq $genome $hamming > double_mutant.txt # output as follows: phenotype, ancestor sequence, novel sequence after purifying selection having the same phenotype, Hamming distance
rm analyze.cfg
