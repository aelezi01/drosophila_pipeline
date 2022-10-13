#!/usr/bin/env nextflow

sample_info =
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv")
        .splitCsv(header:true)
        .map{[ it , it["species"], it["genome"], it["bam"], it["gtf"]]}

species = sample_info.map{it[0]["species"]}.unique()

other_sample = 
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet.csv")
        .splitCsv(header:true)
        .map{[ it , it["species"], it["genome"], it["gtf"]]}


genome = other_sample.map{it[0]["genome"]}.unique()
gtf = other_sample.map{it[0]["gtf"]}.unique()


include { genome_idx } from "./modules/star"

workflow {
    genome_idx(species, genome, gtf)
}

/*

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
    merging_bam(star.out.map{[ it , it["species"], it["bam"], it["gene"]]})
    braker(merging_bam.out)
    gffread_bed(braker.out)
    cds_filtering(gffread_bed.out)
    emboss(cds_filtering.out)
    busco(emboss.out)
    orthofinder(emboss.out)
}

*/