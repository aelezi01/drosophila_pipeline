#!/bin/bash

# submit job to slurm
#SBATCH --partition=cpu
#SBATCH --ntasks=2
#SBATCH --mem=60G
#SBATCH --nodes=2
#SBATCH --time=6:00:0
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name busco_ju
#SBATCH --array=1-5

# create and move to the scratch directory
SCRATCH_DIRECTORY=/camp/stp/babs/scratch/elezia/godinol/juan.ramos/bedtools_busco/
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}

# load modules
ml purge 
ml BUSCO/4.0.5-foss-2019b-Python-3.7.4
ml BLAST+/2.9.0-iimpi-2019b

export BUSCO_CONFIG_FILE=/camp/stp/babs/working/elezia/busco_config.ini
export AUGUSTUS_CONFIG_PATH=/camp/stp/babs/working/elezia/Augustus/config/

# select species name using array task number as an index
species=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $3 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.txt)
echo ${species}

# define the files directory 
dir=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/

# run BUSCO using nucleotide sequences
busco -m proteins \
-i $dir/orthofinder/bedfile/${species}_prot.fasta \
-o ${species}_bedfile_busco \
-f \
--augustus_species /camp/stp/babs/working/elezia/Augustus/config/species/ \
-l diptera_odb10