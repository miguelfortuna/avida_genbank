#!/bin/bash

rand_alf=$(shuf -ez a b c d e f g h i j k l m n o p q r s t u v w x y z)
./random_genotypes 10000 100 $RANDOM $rand_alf > rand_seq.txt # print 10000 genomes

