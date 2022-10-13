sample_info = Channel.fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv").splitCsv(header:true)

process braker {
    module 'BRAKER/2.1.6-intel-2019b-Python-3.7.4'
    module 'cdbfasta/0.99-GCC-8.3.0'
    module 'DIAMOND/0.9.30-GCC-8.3.0'

    scratch true

    input:
        tuple val(species), val(gen), val(bam)
        val metadata
    output:
        path "${species}.gtf"
    script:

        species = metadata["species"]
        gen = metadata["genome"]
        bam = metadata["bam"]

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