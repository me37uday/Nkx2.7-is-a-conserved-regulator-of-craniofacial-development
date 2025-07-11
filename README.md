# Nkx2.7 in Craniofacial Development: Single-Cell RNA-Seq Analysis

This repository contains all analysis code for the single-cell RNA sequencing study of wild-type and nkx2.7-/- zebrafish craniofacial development.

## Data Availability

### Raw Data Download
The raw sequencing data used in this study is available at:  
**GEO Accession:** [GSE240780](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE240780)  


#### How to Download

1. **Download processed files directly**:  
   - From the [GEO record](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE240780):
     - Download `annotated_seurat.rds` for the full processed dataset
2. **Download raw data via `sra-tools`** (command line):  
   ```bash
   prefetch SRR25634296  # Replace with SRR25634297 for WT sample
   fastq-dump --split-files SRR25634296
Processed Data
Annotated Seurat object: Available in the GEO submission

Interactive exploration: [SCP2431](https://singlecell.broadinstitute.org/single_cell/study/SCP2431/nkx2-7-is-a-conserved-regulator-of-craniofacial-development)

Analysis Pipeline
Step 1: Raw Data Processing
bash
# Align reads to reference genome
bash scripts/cellranger.sh
Step 2: Single-Cell Analysis
bash
# Quality control and preprocessing
Rscript scripts/single_cell_analysis_using_seurat.R
Output: Unannotated Seurat object (unannotated_seurat.rds)

Step 3: Cell Type Annotation
bash
# Cluster identification and annotation
Rscript scripts/cell_type_annotation.R
Outputs:

Annotated Seurat object (annotated_seurat.rds)

UMAP plots (umap.pdf)

Marker gene dot plots (cell_type_markers.pdf)

Step 4: Cranial Neural Crest Analysis
bash
# Differential expression analysis
Rscript scripts/cranial_neural_crest_analysis.R
Outputs:

DEG tables (cnc_KO_vs_WT_DEGs.csv)

Volcano plots (cnc_volcano.pdf)

Processed subset (cranial_neural_crest_subset.rds)

Repository Structure
text
nkx2.7_craniofacial_scRNAseq/
├── data/                   # Processed data files
├── scripts/
│   ├── cellranger.sh       # Raw data alignment
│   ├── single_cell_analysis_using_seurat.R  # QC and preprocessing
│   ├── cell_type_annotation.R               # Cluster annotation
│   └── cranial_neural_crest_analysis.R      # KO vs WT analysis
├── figures/                # Output figures
└── README.md               # This file
Dependencies
CellRanger (v6.1.2)

Seurat (v4.1.0+)

R Packages:

r
install.packages(c("Seurat", "ggplot2", "ggrepel", "viridis", "dplyr"))
Citation
If you use this code or data, please cite our publication:
[Your Paper Title]. [Journal Name] [Year]. DOI: [XXXX/XXXX]
