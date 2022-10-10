#!/bin/bash

# Submit job to slurm
#SBATCH --partition=cpu
#SBATCH --ntasks=2
#SBATCH --mem=60G
#SBATCH --nodes=2
#SBATCH --time=1:00:0
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name emboss_ae_ju
#SBATCH --array=1-5

## we want to convert nucleotide sequences to amino acid sequences for each species using EMBOSS/transeq

# load modules
ml purge 
ml EMBOSS/6.6.0-foss-2016b

# select species name using array task number as an index
species=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $3 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.txt)
echo ${species}

# define the files directory 
dir=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/


# run EMBOSS 
transeq -sequence $dir/gffread/${species}_filtered_nucl_1.fasta  -outseq $dir/gffread/${species}_prot_1.fasta -frame 1
transeq -sequence $dir/gffread/${species}_filtered_nucl_2.fasta  -outseq $dir/gffread/${species}_prot_2.fasta -frame 2
transeq -sequence $dir/gffread/${species}_filtered_nucl_3.fasta  -outseq $dir/gffread/${species}_prot_3.fasta -frame 3

## merge the output files into individual proteomic fasta files for each species using the cat command
## save these files in $dir/orthofinder/bedfile/

cat $dir/gffread/${species}_prot_1.fasta $dir/gffread/${species}_prot_2.fasta $dir/gffread/${species}_prot_3.fasta > $dir/orthofinder/bedfile/${species}_prot.fasta