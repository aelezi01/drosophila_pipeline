#!/bin/bash


# Submit job to slurm
#SBATCH --partition=cpu
#SBATCH --ntasks=4
#SBATCH --mem=150G
#SBATCH --nodes=2
#SBATCH --time=3-0:00:0
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name ortho_ju


# create and move to the scratch directory
SCRATCH_DIRECTORY=/camp/stp/babs/scratch/elezia/godinol/juan.ramos/orthofinder/6.4.bedfile
mkdir -p ${SCRATCH_DIRECTORY}

cd ${SCRATCH_DIRECTORY}


# load modules
ml purge 
ml  OrthoFinder/2.5.4-foss-2020b


# directory storing all fasta files to be analysed
DIR=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/orthofinder/bedfile/


# run orthofinder
orthofinder -t 32 -f $DIR

# return to the working directory 
cd ${SLURM_SUBMIT_DIR}

echo "Done!"
