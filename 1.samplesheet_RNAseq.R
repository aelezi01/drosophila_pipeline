# setting up renv environment
renv::init()
renv::snapshot()

# install packages 
# renv::install("tidyverse")
# renv::install("here")
# renv::install("openxlsx")

# loading packages
library(tidyverse)
library(here)
library(openxlsx)

original_design <- readxl::read_xlsx(here("data", "input", "RN19099_dros_samples_Areda.xlsx"))

# extract sample name
samplesheetFile <- original_design[c("sample-limsid", "species")]

# rename sample column and add strandedness
samplesheetFile <- samplesheetFile %>% 
  rename(sample = `sample-limsid`)

# add fastq1 and fast2 location info

## create sublist with only fastq* file paths
fastq_path <- here("data", "input", "fastq")
fastq1_list <- list.files(fastq_path, full.names = TRUE, pattern = "R1") 
fastq2_list <- list.files(fastq_path, full.names = TRUE, pattern = "R2")

## create tibbles with fastq* location and sample names
fastq1_tibble <- fastq1_list %>%
  enframe(value = "fastq_1") %>% 
  select(-name) %>% 
  mutate(sample = basename(fastq_1) %>% str_remove("_S\\d*_L\\d*_R1_001.fastq.gz"))

fastq2_tibble <- fastq2_list %>%
  enframe(value = "fastq_2") %>%
  select(-name) %>%
  mutate(sample = basename(fastq_2) %>% str_remove("_S\\d*_L\\d*_R2_001.fastq.gz"))


## merge tibbles to samplesheetFile, match location to the correct sample by using the sample name
samplesheetFile <- merge(samplesheetFile, fastq1_tibble, by = "sample")
samplesheetFile <- merge(samplesheetFile, fastq2_tibble, by = "sample")

# add a column for the genome paths
samplesheetFile <- samplesheetFile %>% add_column(genome = "")

# save the completed table as a csv file
write.csv(samplesheetFile, here("data", "input", "RN19099_samplesheet.csv"), row.names = FALSE)
