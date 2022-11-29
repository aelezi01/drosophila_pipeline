process fun2 {

    input:
        val ch
    output:
        path "${species2}_2.txt" 
    script:
        species = "${ch[2]["Species"]}"
        smth = "${species}.txt"
        species2 = species.replace(" ", "_")
        /*sed -i '\''s/\r$//'\'' */
        /*        str='${"${species}"// /_}'*/
        """

        
        head ${ch[0]} > "${species2}"_2.txt
        """
}