#!/bin/bash python
import multiprocessing
import os
import argparse



def input_path(input):
    if os.path.isfile(input):
        return input
    else:
        raise argparse.ArgumentTypeError('File path %s is incorrect or doesn\'t exist' %input)



# define optional arguments required to run this script
parser = argparse.ArgumentParser()
parser.add_argument("-star", 
    help="aligns reads and runs all downstream analysis", 
    type=input_path 
    )

parser.add_argument("-braker", 
    help="creates GTF file and runs all downstream analysis", 
    type=input_path 
    )

parser.add_argument("-gffread", 
    help="creates fasta files and runs all downstream analysis", 
    type=input_path 
    )

parser.add_argument("-orthofinder", 
    help="runs orthofinder and busco", 
    type=input_path 
    )

parser.add_argument("-busco", 
    help="creates a busco report", 
    type=input_path 
    )

args = parser.parse_args()



#### define DAG

####### test multiprocessing
p1 = multiprocessing

p1.start()
p1.join()

print(range(10, 20))
### run DAG from different points based on input

# if no args.input:
#     run everything

# if args.input:
#     run from the step corresponding to the input




# add unit testing too



