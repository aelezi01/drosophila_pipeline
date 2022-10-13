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
        val genome
        val gtf
        
    output:
        path "${species}/genome_idx"
    script:

    """ 
    # run STAR for the indexing
    STAR --runThreadN 15 \
    --runMode genomeGenerate \
    --genomeDir "${species}"/genome_idx \
    --genomeFastaFiles "${genome}"    \
    --sjdbGTFfile "${gtf}"    \
    --sjdbOverhang 100 \
    --genomeSAindexNbases 12
    """
}


process star {
    
    module 'STAR/2.7.9a-GCC-10.3.0'
    module 'SAMtools/1.13-GCC-10.2.0'
    
    scratch true 

    input:
        val species
        val genome_idx
        val fastq_1
        val fastq_2

    output:
        path "${outy}.bam"
    script:
    
        gen = metadata["genome_idx"]
        fas1 = metadata["fastq_1"]
        fas2 = metadata["fastq_2"]
        outy = metadata["Sample"]

        """
        STAR \
        --runThreadN 15 \
        --readFilesCommand zcat \
        --genomeDir "${gen}" \
        --readFilesIn "${fas1}" "${fas2}" \
        --outFileNamePrefix "${outy}" \
        --outSAMtype BAM SortedByCoordinate \
        --twopassMode Basic \
        --outSAMstrandField intronMotif \
        --outFilterIntronMotifs RemoveNoncanonical \
        --outSAMattrIHstart 0
        """

}
