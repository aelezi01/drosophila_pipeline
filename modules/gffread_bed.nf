sample_info = Channel.fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv").splitCsv(header:true)

process gffread_bed {

    scratch true

    input:
        val metadata
    output:
        path "${species}_filtered_nucl_allframes.fasta"
    script:

        species = metadata["species"]
        gen = metadata["genome"]

        braker_gtf="/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/BRAKER/${species}.gtf"
        in_dir="/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/bed_file/"
        out_dir="/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/gffread/"


        """
        # Remove the transcript lines from the gtf and transform it to a bed file save it to species.bed
        awk '$3!="transcript"'  $braker_gtf | gffread --bed > $in_dir/"${species}".bed

        # Extract the sequences with gffread using the original genome and the bed files
        gffread -w $out_dir/"${species}"_filtered_nucl_allframes.fasta -g "${gen}" $in_dir/"${species}".bed
        """
}