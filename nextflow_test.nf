#!/usr/bin/env nextflow


params {

}

// import individual modules 

include { genome_idx, star } from "./modules/star"
include { merging_bam } from "./modules/merging_bam"
include { braker } from "./modules/braker"
include { gffread_bed } from "./modules/gffread_bed"
include { cds_filtering } from "./modules/cds_filtering"
include { emboss } from "./modules/emboss"
include { busco } from "./modules/busco"
include { orthofinder } from "./modules/orthofinder"


workflow {
    star()
    merging_bam(star.out)
    braker(merging_bam.out)
    gffread_bed(braker.out)
    cds_filtering(gffread_bed.out)
    emboss(cds_filtering.out)
    busco(emboss.out)
    orthofinder(emboss.out)
}