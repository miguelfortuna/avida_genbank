# <a href="https://github.com/miguelfortuna/avida_genbank/blob/master/The%20genotype-phenotype%20map%20of%20an%20evolving%20organism.pdf" target="_blank">The genotype-phenotype map of an evolving digital organism.</a>

# Configuration files and bash scripts used in this study: 

## <a href="https://github.com/devosoft/avida" target="_blank">Avida version 2.14.0</a>  

Configuration files required
- avida.cfg (the Avida default file was used and some configuration options were modified when Avida was executed in standard and analyze modes).
- events.cfg (renamed when running the directional selection process).
- environment.cfg (renamed when running the three different process indicated below).
- instset-heads.cfg
- avida (executable: compiled for amd64).


# The <a href="http://miguelfortuna.es/avida_genbank" target="_blank">database</a> was generated following these three steps:

## 1. Random exploration of genotype space ###
### files provided:
- random_genotypes.c (source file).
- random_genotypes (compiled for amd64 from the source file).
- random_genotypes.sh
- bash_script_random_exploration_genotype_network.sh
### execution:
```
./random_genotypes.sh # it generates 10000 random genotypes that are stored in the output file "rand_seq.txt".
```
```
./bash_script_random_exploration_genotype_network.sh # it takes those random genotypes and check viability and phenotype in analyze mode.
```

## 2. Directional selection process ###
### files provided:
- merely_viable_sequences.txt (1000 genotypes corresponding to merely viable organisms resulting from the exploration of genotype space)
- convert_seq_into_org.sh (translates a genotype into an organism's file)
- instructions.txt (it maps the letters from a genotype to the instructions specified in the instruction set file "instset-heads.cfg")
- merely_viable_organisms (folder containing 1000 merely viable organisms resulting from the random exploration of genotype space).
- bash_script_directional_selection_process.sh
### execution:
```
./convert_seq_into_org.sh # it takes the genotypes, creates one organism'file per genotype, and store them (merely viable organisms folder)
```
```
./bash_script_directional_selection_process.sh # it finds and selects randomly one genotype having a distinct phenotype using "ancestor_1.org" (from the "merely_viable_organisms" folder) as the seed of the evolutionary process.
```

## 3. Purifying selection process ###
### files provided:
bash_script_purifying_selection_process.sh 
### execution:
```
./bash_script_purifying_selection_process.sh # it performs a double-mutant random walk (i.e., it replaces two instructions at a time) while keeping viability and phenotype, starting from a specific sequence (as an example).
```



[![DOI](https://zenodo.org/badge/89566799.svg)](https://zenodo.org/badge/latestdoi/89566799)
