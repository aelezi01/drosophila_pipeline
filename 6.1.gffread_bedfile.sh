#!/bin/bash

# submit job to slurm
#SBATCH --partition=cpu
#SBATCH --ntasks=4
#SBATCH --mem=120G
#SBATCH --nodes=3
#SBATCH --time=3-0:00:0
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name gffread1_elezia_ju
#SBATCH --array=1-5


# convert gtf files into fastas using gffread

# load modules
ml purge 
ml gffread/0.11.6-GCCcore-9.3.0

# select species name using array task number as an index
species=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $3 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.txt)

# select genome file path for each species using array task number as an index
genSpecies=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $2 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.txt)

echo ${species}
echo ${genSpecies}

# define directories needed
braker_gtf=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/BRAKER/${species}_braker.gtf
in_dir=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/bed_file/
out_dir=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/gffread/

# Remove the transcript lines from the gtf and transform it to a bed file save it to species.bed
awk '$3!="transcript"'  $braker_gtf | gffread --bed > $in_dir/${species}.bed

# Extract the sequences with gffread using the original genome and the bed files
gffread -w $out_dir/${species}_filtered_nucl_allframes.fasta -g ${genSpecies} $in_dir/${species}.bed
