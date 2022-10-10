#!/bin/bash


# submit job to slurm with 17 identical array tasks
#SBATCH --partition=cpu
#SBATCH --ntasks=4
#SBATCH --mem=120G
#SBATCH --nodes=3
#SBATCH --time=3-00:00:0
#SBATCH --mail-user=areda.elezi@crick.ac.uk
#SBATCH --mail-type=FAIL,END
#SBATCH --export=NONE
#SBATCH --job-name STAR_elezia
#SBATCH --array=1-17



# create scratch directory for this job and move into scratch directory
SCRATCH_DIRECTORY=/camp/stp/babs/scratch/elezia/godinol/juan.ramos/STAR/
mkdir -p ${SCRATCH_DIRECTORY}
cd ${SCRATCH_DIRECTORY}


# copy files to the scratch directory that are needed for running STAR in scratch
# cp /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_star.txt ${SCRATCH_DIRECTORY}


## this helps keep track of which array task is being processed
echo "now processing task id: " ${SLURM_ARRAY_TASK_ID}


# select file path for both fastq1 and fastq2 using array task number as an index
fas=$(awk '/_R1_001.fastq.gz/ { if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $4, $5 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_star.txt)

# select genome matching the sample species  
gen=$(awk '/_R1_001.fastq.gz/ { if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $6 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_star.txt)

# get the sample name
outy=$(awk '/_R1_001.fastq.gz/ { if ( FNR == '${SLURM_ARRAY_TASK_ID}' ) print $1 }' /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_star.txt)

echo $fas
echo $outy
echo $gen


# load modules
module load STAR/2.7.9a-GCC-10.3.0
module load SAMtools/1.13-GCC-10.2.0


# run STAR for the alignment
STAR \
--runThreadN 15 \
--readFilesCommand zcat \
--genomeDir ${gen} \
--readFilesIn ${fas} \
--outFileNamePrefix ${outy} \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--outSAMstrandField intronMotif \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMattrIHstart 0


# copy the output back to the working directory and remove scratch folder
cp ${outy}*.bam /camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/STAR/
cd ${SLURM_SUBMIT_DIR}


# remove scratch folder
# rm -rf ${SCRATCH_DIRECTORY}
