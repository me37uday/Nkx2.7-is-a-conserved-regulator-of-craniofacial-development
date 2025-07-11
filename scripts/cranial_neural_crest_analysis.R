#!/usr/bin/env Rscript
# Corrected Cranial Neural Crest DEG Analysis: KO vs WT

library(Seurat)
library(ggplot2)
library(ggrepel)

# 1. LOAD DATA
seurat_obj <- readRDS("annotated_seurat.rds")

# Verify metadata
if (!all(c("orig.ident", "celltype") %in% colnames(seurat_obj@meta.data))) {
  stop("Missing required metadata columns")
}

# 2. SUBSET ONLY CRANIAL NEURAL CREST CELLS (cluster 4)
cnc_cells <- subset(seurat_obj, subset = celltype == "Cranial neural crest")

# Check cell counts
cat("\nCell counts by genotype:\n")
print(table(cnc_cells$orig.ident))

# 3. SET UP FOR DGE
DefaultAssay(cnc_cells) <- "RNA"
Idents(cnc_cells) <- "orig.ident"  # KO vs WT comparison

# 4. DIFFERENTIAL EXPRESSION
markers <- FindMarkers(
  cnc_cells,
  ident.1 = "KO",
  ident.2 = "WT",
  min.pct = 0.1,
  logfc.threshold = 0,
  test.use = "wilcox"
)

# Add FDR correction and gene column
markers$gene <- rownames(markers)
markers$p_val_adj <- p.adjust(markers$p_val, method = "fdr")
sig_markers <- markers[markers$p_val_adj <= 0.05, ]

# 5. VOLCANO PLOT
volcano <- ggplot(data = markers, aes(x = avg_log2FC, y = -log10(p_val_adj), 
                           color = ifelse(p_val_adj < 0.05, 
                                          ifelse(avg_log2FC > 0, "Upregulated", "Downregulated"), 
                                          "Not Significant"))) +
    geom_point(alpha = 0.5, size = 3) +
    scale_color_manual(values = c("Upregulated" = "green3", 
                                  "Downregulated" = "#FD8008", 
                                  "Not Significant" = "grey")) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "grey50") +
    geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "grey50") +
    labs(x = "Average log2 fold change", y = "-Log10 adjusted p-value",
         title = "Volcano plot of cranial neural crest DEGs") +
    theme_classic() +
    geom_label_repel(data = markers[markers$gene %in% c("eya1", "six1b", "nr2f5", "jag1b", "hey1", "grem2b"), ], 
                     aes(label = X, fill = "Dorsal"), 
                     size = 7, 
                     box.padding = 0.5, 
                     color = "black", 
                     fontface = "bold",
                     vjust = 0.5) + 
    geom_label_repel(data = markers[markers$gene %in% c( "edn1", "dlx3b", "dlx4a", "dlx4b", "dlx5a", "dlx6a", "barx1", "bmp4", "msx1b", "hand2"), ], 
                     aes(label = X, fill = "Ventral"), 
                     size = 7, 
                     box.padding = 1, 
                     color = "black", 
                     fontface = "bold") +
    guides(color = guide_legend(title = "Regulation"),
           fill = guide_legend(title = "Gene type")) +
    scale_fill_manual(name = "Gene type", values = c("Dorsal" = "#FFFF0A", "Ventral" = "#CC55FF")) +
    theme(
        axis.title.x = element_text(size = 20),
        axis.text.x = element_text(size = 16),
        axis.title.y = element_text(size = 20),
        axis.text.y = element_text(size = 16),
        plot.title = element_text(size = 25, face = "bold"),
        legend.title = element_text(size = 25, face = "bold"), #change legend title font size
        legend.text = element_text(size = 20))

# 6. SAVE OUTPUTS
write.csv(markers, "cnc_KO_vs_WT_DEGs.csv")
pdf("cnc_volcano.pdf", width = 8, height = 6)
print(volcano)
dev.off()

# 7. BOXPLOT 
# boxplot_data available at Nkx2.7-is-a-conserved-regulator-of-craniofacial-development/data

ggplot(boxplot_data, aes(x = Gene, y = Expression, fill = orig.ident)) +
    geom_boxplot(outlier.size = 0.2, alpha = 0.5) + 	
    scale_fill_manual(values = c("WT" = "#0071FF", "KO" = "#FB0207"), name = "Condition") +
    xlab("Genes") + ylab("Expression") +
    facet_wrap(~Gene_Group, scales = "free_x", nrow = 2) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
    ggtitle("Cranial neural crest cells") +
    ylim(0, 4.2) + theme(
        axis.title.x = element_text(size = 20, face = "bold"),
        axis.text.x = element_text(size = 15),
        axis.title.y = element_text(size = 20, face = "bold"),
        axis.text.y = element_text(size = 15),
        plot.title = element_text(size = 25, face = "bold"),
        legend.title = element_text(size=20, face = "bold"), #change legend title font size
        legend.text = element_text(size=15),
        strip.text = element_text(size = 18, face = "bold"))

