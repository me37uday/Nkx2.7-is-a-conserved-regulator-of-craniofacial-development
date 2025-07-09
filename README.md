
---

## 🚀 **Quick Start**
1. **Download raw data** from GEO: [GSE240780](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE240780)  
   (See [`data/README.md`](data/README.md) for details).  
2. **Run the pipeline**:  
   ```bash
   bash scripts/cellranger.sh  # Process FastQ files
   Rscript scripts/single_cell_analysis_using_seurat.R  # Run downstream analysis
