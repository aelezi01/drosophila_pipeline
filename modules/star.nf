sample_info = Channel.fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet.csv").splitCsv(header:true)

process genome_idx {
    
    scratch true 

    input:

    output:

    script:

    home="/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/genome_flybase/"
    """ 
    # run STAR for the indexing
    STAR --runThreadN 15 \
    --runMode genomeGenerate \
    --genomeDir "${home}"/drosophila.erecta/genome_idx \
    --genomeFastaFiles "${home}"/drosophila.erecta/drosophila_erecta.r1.05.sm.fa    \
    --sjdbGTFfile "${home}"/drosophila.erecta/GCF_003285735.1_DvirRS2_genomic.gtf    \
    --sjdbOverhang 100 \
    --genomeSAindexNbases 12
    """
}


process star {
    module 'STAR/2.7.9a-GCC-10.3.0'
    module 'SAMtools/1.13-GCC-10.2.0'
    
    scratch true 

    input:
        val metadata
    output:
        *.bam
    script:
    
        gen = metadata["genome"]
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
