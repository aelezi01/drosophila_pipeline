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
#SBATCH --job-name braker_elezia_ju
#SBATCH --array=1-5


DIR=/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/

# create scratch directory
SCRATCH_DIRECTORY=/camp/stp/babs/scratch/elezia/godinol/juan.ramos/BRAKER
mkdir -p ${SCRATCH_DIRECTORY}

# move to scratch directory
cd ${SCRATCH_DIRECTORY}


# load modules
ml purge
ml BRAKER/2.1.6-intel-2019b-Python-3.7.4
ml cdbfasta/0.99-GCC-8.3.0
ml DIAMOND/0.9.30-GCC-8.3.0

# assign the correct Augustus paths
export AUGUSTUS_CONFIG_PATH=/camp/stp/babs/working/elezia/Augustus/config/
AUGUSTUS_SCRIPTS_PATH=/camp/stp/babs/working/elezia/Augustus/scripts/


# BRAKER needs to be run once for each species
# select file path for each species using array task number as an index
bamSpecies=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $1 }' $DIR/data/input/RN19099_samplesheet_braker.txt)

# select genome file path for each species using array task number as an index
genSpecies=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $2 }' $DIR/data/input/RN19099_samplesheet_braker.txt)

# select species name using array task number as an index
species=$(awk '{ if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $3 }' $DIR/data/input/RN19099_samplesheet_braker.txt)

echo ${bamSpecies}
echo ${genSpecies}
echo ${species}



# run BRAKER with RNAseq data corresponding to each species
braker.pl --species=${species} \
--genome=${genSpecies} \
--bam=${bamSpecies} \
--cores=8 \
--workingdir=$SCRATCH_DIRECTORY/${species} \
--AUGUSTUS_SCRIPTS_PATH=$AUGUSTUS_SCRIPTS_PATH \
--softmasking \
--useexisting



# return to the working directory 
cd ${SLURM_SUBMIT_DIR}

# copy the output back to the working directory and remove scratch folder