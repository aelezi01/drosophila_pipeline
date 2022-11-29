process braker {
    module 'BRAKER/2.1.6-intel-2019b-Python-3.7.4'
    module 'cdbfasta/0.99-GCC-8.3.0'
    module 'DIAMOND/0.9.30-GCC-8.3.0'

    scratch true

    publishDir "../data/run_*/braker/"

    input:
        val species
        val genome
    output:
        path "${species}.gtf"
    script:

        AUGUSTUS_CONFIG_PATH="/camp/stp/babs/working/elezia/Augustus/config/"
        AUGUSTUS_SCRIPTS_PATH="/camp/stp/babs/working/elezia/Augustus/scripts/"

        """
        braker.pl --species="${species}" \
        --genome="${gen}" \
        --bam="${bam}" \
        --cores=8 \
        --AUGUSTUS_SCRIPTS_PATH=$AUGUSTUS_SCRIPTS_PATH \
        --softmasking \
        --useexisting

        mv braker.gtf "${species}".gtf
        """
}