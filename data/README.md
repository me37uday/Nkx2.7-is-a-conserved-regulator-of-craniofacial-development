# Raw Data Download

The raw sequencing data used in this study is available at:  
**GEO Accession:** [GSE240780](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE240780)  

## File Structure
- `fastq/`: Contains paired-end reads (SRA format).  
- `metadata.csv`: Sample metadata (conditions, replicates, etc.).  

## How to Download
1. **Via GEO**: Follow the link above → Click "SRA Run Selector" → Download `.fastq` files.  
2. **Via `sra-tools`** (command line):  
   ```bash
   prefetch SRR1234567  # Replace with SRA ID
   fastq-dump --split-files SRR1234567
