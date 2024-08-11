# ChIP-seq-workflow

The most recent human reference genome and GTF was downloaded from gencode. Bowtie2 constructed the reference genome 
index using default parameters. Next, fastqc was performed to assess quality metrics. Trimmomatic with phred33 was performed on 
the FASTQ files in order to remove portions of the sequencing adaptor or portions where the quality of the base calls was poor. 

Reads were aligned to the gencode human primary assembly reference genome (GRCm39.p14 release 45) using Bowtie2 v2.5.3 with default parameters. 
Alignment files were sorted and indexed with Samtools v1.19 using default parameters. Samtools flagstat v1.19 and MultiQC v1.21 were used with
default parameters to assess post-alignment quality. bamCoverage v2.2 and multiBigWigSummary v3.5.1 from the deepTools suite v3.5.6 were used with 
default parameters to count alignments in chromosome regions. plotCorrelation v3.5.5 from the deepTools suite v3.5.6 was used with the pearson and 
heatmap parameters to display the pearson correlation values between samples.

The Homer suites's find peaks v.0.1.2 was used with an overlap of at least 90% to identify reproducible peaks. Blacklisted regions 
were filtered out using Bedtools v.2.31.0 with default parameters. Homer's annotate peaks v.0.1.2 using default parameters along with 
Gencode's Primary Human Reference Genome (hg38) annotated the reproducible peaks. Finally, motifs were identified using find motifs 
genome in the Homer suite v.0.1.2 with a bin size of 200. computeMatrix from the deepTools suite v.3.5.6 was used in scale-regions mode with a 2kb window to calculate signal coverage of all genes in the reference genome. plotProfile from the deepTools suite v.3.5.6 was used with default parameters to visualize the signal across genes in the reference genome.
