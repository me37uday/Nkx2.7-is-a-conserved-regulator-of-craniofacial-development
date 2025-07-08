# Code for Nkx2.7-is-a-conserved-regulator-of-craniofacial-development

This repository contains scripts for single-cell RNA-seq analysis.

## Files
- `cellranger.sh`: Processes FastQ files (Cell Ranger v6.1.2).
- `analysis.R`: Performs clustering and DEG analysis.

## Usage
1. Install [Cell Ranger](https://support.10xgenomics.com/).
2. Run scripts:
   ```bash
   bash cellranger.sh
   Rscript analysis.R
