#!/usr/bin/env Rscript
# Complete Single-Cell RNA-seq Analysis Pipeline
# Verified with Seurat v4.1.0

library(Seurat)
library(ggplot2)

# =============================================
# 1. LOAD AND PREPARE DATA
# =============================================

# Set this to your project directory
setwd("YOUR_WORKING_DIRECTORY")  

# Read 10X Genomics data
d1.data <- Read10X(data.dir = "KC001")  # Wild-type sample
d2.data <- Read10X(data.dir = "KC002")  # nkx2.7-/- sample

# Create Seurat objects
d1 <- CreateSeuratObject(counts = d1.data, project = "WT")
d2 <- CreateSeuratObject(counts = d2.data, project = "KO")

# =============================================
# 2. QUALITY CONTROL AND FILTERING
# =============================================

# Calculate mitochondrial percentage (zebrafish pattern "^mt-")
d1[["percent.mt"]] <- PercentageFeatureSet(d1, pattern = "^mt-")
d2[["percent.mt"]] <- PercentageFeatureSet(d2, pattern = "^mt-")

# Convert to ratio (0-1 scale)
d1$mitoRatio <- d1@meta.data$percent.mt / 100
d2$mitoRatio <- d2@meta.data$percent.mt / 100

# Filter cells according to manuscript parameters:
# - Minimum 500 reads
# - 125-8000 genes detected
# - Mitochondrial content < 20%
d1 <- subset(d1, subset = nCount_RNA >= 500 & 
                   nFeature_RNA >= 125 & 
                   nFeature_RNA <= 8000 & 
                   mitoRatio < 0.20)

d2 <- subset(d2, subset = nCount_RNA >= 500 &
                   nFeature_RNA >= 125 &
                   nFeature_RNA <= 8000 &
                   mitoRatio < 0.20)

# =============================================
# 3. DATA NORMALIZATION AND FEATURE SELECTION
# =============================================

# Normalize data (log normalization)
d1 <- NormalizeData(d1, verbose = FALSE)
d2 <- NormalizeData(d2, verbose = FALSE)

# Identify top 2000 variable features (vst method)
d1 <- FindVariableFeatures(d1, 
                         selection.method = "vst",
                         nfeatures = 2000,
                         verbose = FALSE)

d2 <- FindVariableFeatures(d2,
                         selection.method = "vst",
                         nfeatures = 2000,
                         verbose = FALSE)

# =============================================
# 4. DATA INTEGRATION
# =============================================

# Prepare list of objects for integration
d_list <- list(d1, d2)

# Select features for integration
features <- SelectIntegrationFeatures(object.list = d_list)

# Find integration anchors
anchors <- FindIntegrationAnchors(object.list = d_list,
                                anchor.features = features,
                                dims = 1:30)

# Integrate datasets
d_integrated <- IntegrateData(anchorset = anchors, dims = 1:30)

# =============================================
# 5. DIMENSIONAL REDUCTION AND CLUSTERING
# =============================================

# Switch to integrated assay
DefaultAssay(d_integrated) <- "integrated"

# Scale data and run PCA
d_integrated <- ScaleData(d_integrated, verbose = FALSE)
d_integrated <- RunPCA(d_integrated, npcs = 30, verbose = FALSE)

# Find neighbors and cluster (resolution = 0.12)
d_integrated <- FindNeighbors(d_integrated, reduction = "pca", dims = 1:30)
d_integrated <- FindClusters(d_integrated, resolution = 0.12)

# Run UMAP
d_integrated <- RunUMAP(d_integrated, reduction = "pca", dims = 1:30)

# =============================================
# 6. EXPORT SEURAT OBJECT
# =============================================

# Save the integrated object
saveRDS(d_integrated, "integrated_seurat.rds")

