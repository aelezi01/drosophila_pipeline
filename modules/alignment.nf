/*
sample_info = Channel.fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet.csv").splitCsv(header:true)
*/

process genome_idx {
    
    module 'STAR/2.7.9a-GCC-10.3.0'
    module 'SAMtools/1.13-GCC-10.2.0'
    
    scratch true 
    publishDir "../data/genome/"

    input:
        val species
        val original_genome
        val gtf
        
    output:
        path "${species}/genome_idx"
    script:

    """ 
    # run STAR for the indexing
    STAR --runThreadN 15 \
    --runMode genomeGenerate \
    --genomeDir "${species}"/genome_idx \
    --genomeFastaFiles "${original_genome}"    \
    --sjdbGTFfile "${gtf}"    \
    --sjdbOverhang 100 \
    --genomeSAindexNbases 12
    """
}


process star {

    module 'STAR/2.7.9a-GCC-10.3.0'
    module 'SAMtools/1.13-GCC-10.2.0'
    
    scratch true 
    publishDir "../data/run_*/star/"

    input:
        val samples
        val genome_idx
        val fastq_1
        val fastq_2

    output:
        path "${samples}.bam"
    script:

        """
        STAR \
        --runThreadN 15 \
        --readFilesCommand zcat \
        --genomeDir "${genome_idx}" \
        --readFilesIn "${fastq_1}" "${fastq_2}" \
        --outFileNamePrefix "${samples}" \
        --outSAMtype BAM SortedByCoordinate \
        --twopassMode Basic \
        --outSAMstrandField intronMotif \
        --outFilterIntronMotifs RemoveNoncanonical \
        --outSAMattrIHstart 0
        """
}

process merging_bam {
    module SAMtools/1.13-GCC-10.2.0

    publishDir "../data/run_*/star/"
    
    input:
        val star.out
    output:
        path "${species}_sorted.bam"
    script:
        """
        samtools merge "${species}".bam "${sample}"Aligned.sortedByCoord.out.bam

        samtools sort -o "${species}"_sorted.bam "${species}".bam
        """

}