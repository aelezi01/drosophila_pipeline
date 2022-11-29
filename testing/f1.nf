process fun1 {

    input:
        val species
        val genome
        val sample
    output:
        tuple path("${nam}.txt"), val("${nam}")
         
    script:
        species = "$species"
        gen = "$genome"
        nam = "$sample"
        """
        
        echo "${species}" > ${nam}.txt
        head "${gen}" >> "${nam}".txt


        """
}