#!/bin/bash

# submit job to slurm
#SBATCH --partition=cpu
#SBATCH --ntasks=4
#SBATCH --mem=120G
#SBATCH --nodes=3
#SBATCH --time=24:00:0
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name mergeBAM_elezia


# load modules
ml SAMtools/1.13-GCC-10.2.0

echo START merge and sort: `date`


# move into the input directory
filesDIR=/camp/home/elezia/working/elezia/projects/godinol/juan.ramos/data/output/STAR
cd ${filesDIR}


# merge bam files into single bam files named after the respective species
samtools merge drosophila_erecta.bam FRI345A5Aligned.sortedByCoord.out.bam FRI345A13Aligned.sortedByCoord.out.bam FRI345A14Aligned.sortedByCoord.out.bam

samtools merge drosophila_suzuki.bam FRI345A1Aligned.sortedByCoord.out.bam FRI345A2Aligned.sortedByCoord.out.bam FRI345A3Aligned.sortedByCoord.out.bam FRI345A11Aligned.sortedByCoord.out.bam 

samtools merge drosophila_virilis.bam FRI345A12Aligned.sortedByCoord.out.bam FRI345A127Aligned.sortedByCoord.out.bam FRI345A128Aligned.sortedByCoord.out.bam 

samtools merge drosophila_willistoni.bam FRI345A4Aligned.sortedByCoord.out.bam FRI345A15Aligned.sortedByCoord.out.bam FRI345A126Aligned.sortedByCoord.out.bam 

samtools merge drosophila_melanogaster.bam FRI345A19Aligned.sortedByCoord.out.bam FRI345A9Aligned.sortedByCoord.out.bam FRI345A16Aligned.sortedByCoord.out.bam FRI345A17Aligned.sortedByCoord.out.bam


# final sort of the merged bam file for each species
samtools sort -o drosophila_erecta_sorted.bam drosophila_erecta.bam

samtools sort -o drosophila_suzuki_sorted.bam drosophila_suzuki.bam

samtools sort -o drosophila_virilis_sorted.bam drosophila_virilis.bam

samtools sort -o drosophila_willistoni_sorted.bam drosophila_willistoni.bam

samtools sort -o drosophila_melanogaster_sorted.bam drosophila_melanogaster.bam


# move back to the working directory
cd ${SLURM_SUBMIT_DIR}