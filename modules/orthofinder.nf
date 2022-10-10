process orthofinder {

    scratch true

    input:
    
    output:
    
    script:
    
    DIR="/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/orthofinder/bedfile/"

    """
    # run orthofinder
    orthofinder -t 32 -f $DIR"""
}