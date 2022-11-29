#!/usr/bin/env nextflow

// import sample and species information from samplesheets 

//// info for genome_idx, star
ALIGNMENT_INFO = 
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet.csv")
        .splitCsv(header:true)
        .map{ it << ["species": it["species"].replaceAll(" ", "_")]}

SPECIES = ALIGNMENT_INFO.map{ it["species"]}.unique()
ORIGINAL_GENOME = ALIGNMENT_INFO.map{it["genome"]}.unique()
GTF = ALIGNMENT_INFO.map{it["gtf"]}.unique()
SAMPLES = ALIGNMENT_INFO.map{it["sample"]}
FASTQ_1 = ALIGNMENT_INFO.map{it["fastq_1"]}.unique()
FASTQ_2 = ALIGNMENT_INFO.map{it["fastq_2"]}.unique()

/*
//// info for all the other processes
species_info =
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet_braker.csv")
        .splitCsv(header:true)
        .map{[ it , it["species"], it["genome"], it["bam"], it["gtf"]]}

species = species_info.map{it[0]["species"]}.unique()
genome = species_info.map{it[0]["genome"]}.unique()
bam = species_info.map{it[0]["bam"]}.unique()
gtf = species_info.map{it[0]["gtf"]}.unique()
*/

  

// import individual processes

include { genome_idx } from "./modules/alignment"
include { star } from "./modules/alignment"
/*include { merging_bam } from "./modules/alignment"
include { braker } from "./modules/annotation"
include { gffread_bed } from "./modules/gtf_to_fasta"
include { cds_filtering } from "./modules/gtf_to_fasta"
include { emboss } from "./modules/gtf_to_fasta"
include { busco } from "./modules/busco"
include { orthofinder } from "./modules/orthofinder"
*/



// run workflow

workflow {
    genome_idx(SPECIES, ORIGINAL_GENOME, GTF)
    GIDX = ALIGNMENT_INFO.combine(genome_idx.out)
    GIDX.view()
    /*star(samples, genome_idx.out, fastq_1, fastq_2)
    merging_bam(star.out, species)*/
}

// to do:
///1)save output in log file
///2) send email for completion with user input (argparse)
///3) add check points (if file exist- save as file 2 or whatever)
/// 3) check that input is being put together correctly (species to file) and save this stuff in the log file

/// when all it's done, add testing

/*

// import individual modules 


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