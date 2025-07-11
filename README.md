# Nkx2.7 in Craniofacial Development: Single-Cell RNA-Seq Analysis

This repository contains all analysis code for the single-cell RNA sequencing study of wild-type and nkx2.7-/- zebrafish craniofacial development.

## Data Availability

### Raw Data Download
The raw sequencing data used in this study is available at:  
**GEO Accession:** [GSE240780](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE240780)  

#### File Structure
- `fastq/`: Contains paired-end reads (SRA format)  
- `processed/`: Processed Seurat objects and analysis outputs  

#### How to Download
1. **Via GEO**:  
   - Follow the GEO link above → Click "SRA Run Selector" → Download `.fastq` files  
2. **Via `sra-tools`** (command line):  
   ```bash
   prefetch SRRXXXXXXX  # Replace with your SRA ID
   fastq-dump --split-files SRRXXXXXXX

Processed Data
Annotated Seurat object: Available in the GEO submission

Interactive exploration: Broad Institute Single Cell Portal

## Analysis Pipeline
 
Step 1: Align reads to reference genome
```
bash scripts/cellranger.sh
