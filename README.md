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

### Processed data:

Annotated Seurat object: [GSE240780_seurat_object.rds.gz](https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE240780&format=file&file=GSE240780%5Fseurat%5Fobject%2Erds%2Egz)

Interactive exploration: [SCP2431](https://singlecell.broadinstitute.org/single_cell/study/SCP2431/nkx2-7-is-a-conserved-regulator-of-craniofacial-development)

## Analysis Pipeline
 
Step 1: Align reads to reference genome
   ```
   bash scripts/cellranger.sh
   ```

Step 2: Quality control and preprocessing
   ```
   Rscript scripts/single_cell_analysis_using_seurat.R
   ```
   Output: Unannotated seurat object

Step 3: Cell Type Annotation
   ```
   Rscript scripts/cell_type_annotation.R
   ```
   Outputs:
   
   Annotated Seurat object (annotated_seurat.rds)
   
   UMAP plots (umap.pdf)
   
   Marker gene dot plots (cell_type_markers.pdf)
   
Step 4: Cranial Neural Crest Analysis
   ```
   Rscript scripts/cranial_neural_crest_analysis.R
   ```
   Outputs:
   
   DEG tables (cnc_KO_vs_WT_DEGs.csv)
   
   Volcano plots (cnc_volcano.pdf)
   
   Processed subset (cranial_neural_crest_subset.rds)

### Repository structure

```
nkx2.7_craniofacial_scRNAseq/
├── data/                   # Raw files of figures
├── scripts/
│   ├── cellranger.sh       # Raw data alignment
│   ├── single_cell_analysis_using_seurat.R  # QC and preprocessing
│   ├── cell_type_annotation.R               # Cluster annotation
│   └── cranial_neural_crest_analysis.R      # KO vs WT analysis
└── README.md               # This file
```

### Dependencies

CellRanger (v6.1.2)

Seurat (v4.1.0)

R Packages:
```
install.packages(c("Seurat", "ggplot2", "ggrepel", "viridis", "dplyr"))
```

Citation
If you use this code or data, please cite our publication:
Nkx2.7 is a conserved regulator of craniofacial development. Nature Communications 2025. 

DOI: [https://doi.org/10.1038/s41467-025-58821-3](https://doi.org/10.1038/s41467-025-58821-3)



