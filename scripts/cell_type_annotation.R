#!/usr/bin/env Rscript
# Comprehensive Cell Type Annotation Script
# 1. Finds conserved markers 2. Annotates clusters 3. Generates dot plot

library(Seurat)
library(ggplot2)
library(viridis)

# =============================================
# 1. LOAD AND PREPARE DATA
# =============================================

seurat_obj <- readRDS("integrated_seurat.rds")

# Set cluster identities
Idents(seurat_obj) <- "seurat_clusters"

# =============================================
# 2. FIND CONSERVED MARKERS (YOUR CODE IMPROVED)
# =============================================

# Create directory for marker files
dir.create("marker_files", showWarnings = FALSE)

# Find conserved markers for each cluster
for (i in 0:15) {
  tryCatch({
    cat("\nProcessing cluster", i, "...\n")
    
    markers <- FindConservedMarkers(
      seurat_obj,
      ident.1 = i,
      grouping.var = "orig.ident",
      verbose = TRUE,
      min.pct = 0.25,
      only.pos = TRUE
    )
    
    if (nrow(markers) > 0) {
      write.csv(
        markers,
        file = file.path("marker_files", paste0(i, "_conserved_markers.csv")),
        row.names = TRUE
      )
      cat("Saved markers for cluster", i, "\n")
    } else {
      cat("No significant markers found for cluster", i, "\n")
    }
  }, error = function(e) {
    cat("Error processing cluster", i, ":", conditionMessage(e), "\n")
  })
}

# =============================================
# 3. MANUAL CLUSTER ANNOTATION
# =============================================

cluster_annotations <- c(
  "0" = "Neural 1",
  "1" = "Neural 2",
  "2" = "Pharyngeal mesenchyme",
  "3" = "Neural 3",
  "4" = "Cranial neural crest",
  "5" = "Unassigned",
  "6" = "Neural 4",
  "7" = "Pharyngeal endoderm",
  "8" = "Neural 5",
  "9" = "Sox10_ neural crest",
  "10" = "Eye",
  "11" = "Periderm",
  "12" = "Cardiovascular mesoderm",
  "13" = "Hematopoietic progenitors 1",
  "14" = "Hematopoietic progenitors 2",
  "15" = "Muscle"
)

# Add annotations to Seurat object
seurat_obj$cell_type <- factor(
  cluster_annotations[as.character(seurat_obj$seurat_clusters)],
  levels = cluster_annotations
)

# =============================================
# 4. MARKER GENE DOT PLOT
# =============================================

# Define all marker genes from your description
marker_genes <- c(
# Pharyngeal mesenchyme (cluster 2)
  "fmoda", "col9a3", "cxcl12a", "col5a1",
# Pharyngeal endoderm (cluster 7)
  "krt91", "epcam", "col1a1b", "krt4",
# Cranial neural crest (cluster 4)
  "grem2b", "twist1a", "dlx2a", "dlx5a",
# Sox10+ neural crest (cluster 9)
  "sox10", "foxd3", "crestin",
# Neural 1 (cluster 0)
  "sox3", "sox19a", "notch3", "lrrn1",
# Neural 2 (cluster 1)
  "onecut1", "elavl3", "elavl4",
# Neural 3 (cluster 3)
  "sox3", "mdka", "lrrn1",
# Neural 4 (cluster 6)
  "mdka", "notch3", "elavl3", "sox3", "sox19a",
# Neural 5 (cluster 8)
  "mdka", "notch3", "sox3", "lrrn1",
# Eye (cluster 10)
  "six1b", "neurod1",
# Periderm (cluster 11)
  "cyt1l", "cyt1", "krt5",
# Cardiovascular mesoderm (cluster 12)
  "aqp1a.1", "cldn5b", "sox7",
# Hematopoietic progenitors 1 (cluster 13)
  "hbbe3", "hbbe1.3", "hbae3", "hbae1.3", "hbbe1.2", "hbbe1.1", "hbae1.1", "hbae1.3.1", "hbbe2",
# Hematopoietic progenitors 2 (cluster 14)
  "lyz", "spi1b",
# Muscle (cluster 15)
  "mylpfa", "actc1b", "myl1", "myhz1.1"
)

# Generate dot plot with all markers
dot_plot <- DotPlot(
  object = seurat_obj,
  features = marker_genes,
  group.by = "cell_type",
  cols = viridis(10),
  dot.scale = 6,
  scale = TRUE
) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
    axis.text.y = element_text(size = 10),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    legend.position = "right",
    legend.box = "vertical"
  ) +
  labs(
    x = "Cell Type",
    y = "Marker Genes",
  ) +
  coord_flip()

# Save plot
pdf("cell_type_markers_dotplot.pdf", width = 14, height = 12)
print(dot_plot)
dev.off()

# =============================================
# 5. SAVE ANNOTATED OBJECT
# =============================================

saveRDS(seurat_obj, "annotated_seurat.rds")
