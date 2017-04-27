#! /bin/bash

echo "PURGE_BATCH" > analyze.cfg

while read sequence
do
	echo "LOAD_SEQUENCE" $sequence >> analyze.cfg
done < rand_seq.txt

echo "RECALCULATE" >> analyze.cfg
echo "DETAIL output.txt viable sequence task_list" >> analyze.cfg
	
./avida -a -set ENVIRONMENT_FILE environment_random_exploration_genotype_space.cfg -set COPY_MUT_PROB 0 -set DIVIDE_INS_PROB 0 -set DIVIDE_DEL_PROB 0 -set OFFSPRING_SIZE_RANGE 1 -set MIN_COPIED_LINES 0 -set MIN_EXE_LINES 0 -set REQUIRE_EXACT_COPY 1 -set STERILIZE_UNSTABLE 1 -set DEATH_METHOD 0 > /dev/null 2>&1
