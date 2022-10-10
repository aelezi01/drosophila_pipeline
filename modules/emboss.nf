sample_info = Channel.fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv").splitCsv(header:true)

process emboss {

    scratch true

    input:
        val metadata
    output:
    
    script:

        species = metadata["species"]

        dir="/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/"

        """
        # run EMBOSS 
        transeq -sequence $dir/gffread/"${species}"_filtered_nucl_1.fasta  -outseq $dir/gffread/"${species}"_prot_1.fasta -frame 1
        transeq -sequence $dir/gffread/"${species}"_filtered_nucl_2.fasta  -outseq $dir/gffread/"${species}"_prot_2.fasta -frame 2
        transeq -sequence $dir/gffread/"${species}"_filtered_nucl_3.fasta  -outseq $dir/gffread/"${species}"_prot_3.fasta -frame 3

        ## merge the output files into individual proteomic fasta files for each species using the cat command
        ## save these files in $dir/orthofinder/bedfile/

        cat $dir/gffread/"${species}"_prot_1.fasta $dir/gffread/"${species}"_prot_2.fasta $dir/gffread/"${species}"_prot_3.fasta > $dir/orthofinder/bedfile/"${species}"_prot.fasta
        """
}