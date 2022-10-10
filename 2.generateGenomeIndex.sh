#!/bin/bash

# submit job to slurm
#SBATCH --time=06:00:00
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name=STAR_index_elezia
#SBATCH --partition=cpu
#SBATCH --mem=120G

home=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/genome_flybase/


# load modules
module load STAR/2.7.9a-GCC-10.3.0
module load SAMtools/1.13-GCC-10.2.0


# run STAR for the indexing
STAR --runThreadN 15 \
--runMode genomeGenerate \
--genomeDir ${home}/drosophila.erecta/genome_idx \
--genomeFastaFiles ${home}/drosophila.erecta/drosophila_erecta.r1.05.sm.fa    \
--sjdbGTFfile ${home}/drosophila.erecta/GCF_003285735.1_DvirRS2_genomic.gtf    \
--sjdbOverhang 100 \
--genomeSAindexNbases 12 

