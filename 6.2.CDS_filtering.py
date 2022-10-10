# to make this run in CAMP, run this command first:
# module load Biopython/1.78-fosscuda-2020b


# split the fasta file into 3 subfiles depending on the frame of each annotated gene

from Bio import SeqIO
import os

PATH = "/camp/stp/babs/working/elezia/projects/godinol/juan.ramos/data/output/gffread"
SPECIES = "melanogaster"
basename = "drosophila_" + SPECIES + "_filtered_nucl_"
file = os.path.join(PATH, basename + "allframes.fasta")


def filter_by_cds(file, cds):
    frame = "CDS=" + str(cds) + "-"
    CDS = []
    for record in SeqIO.parse(file, "fasta"):
        if frame in record.description:
            CDS.append(record)
    
    file_name = basename + str(cds) + ".fasta"
    new_file = os.path.join(PATH, file_name)
    SeqIO.write(CDS, new_file, "fasta")

filter_by_cds(file, 1)
filter_by_cds(file, 2)
filter_by_cds(file, 3)
