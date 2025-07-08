#!/bin/bash
REFERENCE="/path/to/Danio.rerio_genome"
FASTQ_DIR="/path/to/fastqs"

# Process KC001
cellranger count \
  --id KCOO1 \
  --transcriptome="$REFERENCE" \
  --fastqs="$FASTQ_DIR/KC001" \
  --sample KC001 \
  --localcores 40 \
  --localmem 100

# Process KC002
cellranger count \
  --id KCOO2 \
  --transcriptome="$REFERENCE" \
  --fastqs="$FASTQ_DIR/KC002" \
  --sample KC002 \
  --localcores 40 \
  --localmem 100
