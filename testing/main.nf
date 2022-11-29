
alignment_info = 
    Channel
        .fromPath("/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/input/RN19099_samplesheet.csv")
        .splitCsv(header:true)
        .map{[ it ]}

include { fun1 } from "./f1"
include { fun2 } from "./f2" 


species = alignment_info.map{it[0]["Species"]}.unique()
genome = alignment_info.map{it[0]["Genome"]}
sample = alignment_info.map{it[0]["Sample"]}

workflow {

    fun1(species, genome, sample)
    ch1 = fun1.out
    ch = ch1.combine(alignment_info).filter{ it[1] == it[2]["Sample"] }
    ch.view()
    fun2(ch)
    fun2.out.view() 
}