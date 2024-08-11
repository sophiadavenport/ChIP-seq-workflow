library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)
#goal: plot "RUNX1 peak binding within +/− 5kb of differentially expressed gene promoters, as well as +/− 20kb of 
#differentially expressed gene bodies"

path <- "results/GSE75070_MCF7_shRUNX1_shNS_RNAseq_log2_foldchange.txt.gz"

data <- read_delim(file = gzfile(path), delim = "\t") %>% as_tibble()

#used 0.01 < padj and 1 > absolute value of log2FoldChange
filtered_data <- data %>% filter(padj < 0.01, abs(log2FoldChange) > 1)

up_regulated <- filtered_data %>% filter(log2FoldChange > 0) #687 up-regulated genes
down_regulated <- filtered_data %>% filter(log2FoldChange < 0) #466 down-regulated genes
count_upregulated <- nrow(up_regulated)
count_downregulated <- nrow(down_regulated)

annotations <- "results/annotated_peaks.txt"
annotation_data <- read_delim(file = annotations, delim = "\t") %>% as_tibble() %>% select(`Gene Name`, `Distance to TSS`)

joined_data <- right_join(annotation_data, filtered_data, by = c("Gene Name" = "genename"))
joined_data <- joined_data %>% mutate(regulated = ifelse(`log2FoldChange`<0, "Down-regulated", "Up-regulated"))

#within +/- 5 kb
data5 <- joined_data %>% mutate(within = ifelse(abs(`Distance to TSS`) <= 5000 & !is.na(`Distance to TSS`), "Bound", "Unbound"))
data5 <- data5 %>% mutate(regulated= ifelse(`log2FoldChange`<0, "5_Down-regulated", "5_Up-regulated"))

#within +/- 20 kb
data20 <- joined_data %>% mutate(within = ifelse(abs(`Distance to TSS`) <= 20000 & !is.na(`Distance to TSS`), "Bound", "Unbound"))
data20 <- data20 %>% mutate(regulated= ifelse(`log2FoldChange`<0, "20_Down-regulated", "20_Up-regulated"))

#within +/- 100 kb
data100 <- joined_data %>% mutate(within = ifelse(abs(`Distance to TSS`) <= 100000 & !is.na(`Distance to TSS`), "Bound", "Unbound"))
data100 <- data100 %>% mutate(regulated= ifelse(`log2FoldChange`<0, "100_Down-regulated", "100_Up-regulated"))

head(data5)

p<- ggplot() +
  geom_bar(data=data5, aes(x = regulated, y=nrow(data5), fill = within), stat = "identity", position = "fill") +
  geom_bar(data = data20, aes(x = regulated, y=nrow(data20), fill = within), stat = "identity", position = "fill") +
  geom_bar(data = data100, aes(x = regulated, y=nrow(data100), fill = within), stat = "identity", position = "fill") +
  scale_y_continuous(labels = scales::percent_format(scale = 100)) +
  scale_x_discrete(limits = c("5_Up-regulated", "5_Down-regulated", "20_Up-regulated", "20_Down-regulated", "100_Up-regulated", "100_Down-regulated")) +
  labs(x = "+/- 5kb of TSS, +/- 20kb of TSS, +/- 100kb of TSS", y = "Percentage of Genes") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("plot.png", p, width = 10, height = 6, units = "in")