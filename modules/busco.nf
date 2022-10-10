sample_info = Channel.fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv").splitCsv(header:true)

process busco {
    module 'BUSCO/4.0.5-foss-2019b-Python-3.7.4'
    module 'BLAST+/2.9.0-iimpi-2019b'

    scratch true

    input:
        val metadata
    output:
        
    script:
        species = metadata["species"]

        BUSCO_CONFIG_FILE="/camp/stp/babs/working/elezia/busco_config.ini"
        AUGUSTUS_CONFIG_PATH="/camp/stp/babs/working/elezia/Augustus/config/"

        """
        busco -m proteins \
        -i $dir/orthofinder/bedfile/"${species}"_prot.fasta \
        -o "${species}"_bedfile_busco \
        -f \
        --augustus_species /camp/stp/babs/working/elezia/Augustus/config/species/ \
        -l diptera_odb10
        """
}