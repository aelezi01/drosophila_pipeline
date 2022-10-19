#!/usr/bin/env nextflow

// import sample and species information from samplesheets 

alignment_info = 
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet.csv")
        .splitCsv(header:true)
        .map{[ it , it["Sample"], it["genome"], it["gtf"], it["fastq_1"], it["fastq_2"]]}


original_genome = alignment_info.map{it[0]["genome"]}.unique()
gtf = alignment_info.map{it[0]["gtf"]}.unique()
samples = alignment_info.map{it[0]["Sample"]}
fastq_1 = alignment_info.map{it[0]["fastq_1"]}.unique()
fastq_2 = alignment_info.map{it[0]["fastq_2"]}.unique()


species_info =
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv")
        .splitCsv(header:true)
        .map{[ it , it["species"], it["genome"], it["bam"], it["gtf"]]}

species = species_info.map{it[0]["species"]}.unique()
genome = species_info.map{it[0]["genome"]}.unique()
bam = species_info.map{it[0]["bam"]}.unique()
gtf = species_info.map{it[0]["gtf"]}.unique()


// import individual processes

include { genome_idx, star, merging_bam } from "./modules/alignment"
include { braker } from "./modules/annotation"
include { gffread_bed, cds_filtering, emboss } from "./modules/gtf_to_fasta"
include { busco } from "./modules/busco"
include { orthofinder } from "./modules/orthofinder"


// run workflow

workflow {
    genome_idx(species, original_genome, gtf)
    star(samples, genome_idx.out, fastq_1, fastq_2)
    merging_bam(star.out, species)
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