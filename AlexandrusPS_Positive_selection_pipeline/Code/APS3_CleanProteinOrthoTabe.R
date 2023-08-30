library(dplyr)
# library(ggplot2)
# library(caret)
# library(reshape2)
# library(ggpubr)
# library(RColorBrewer)
# library(stringr)
# library(viridis)
# library(ggpubr)

POGF_all <- read.delim("ProteinOrthoTable.proteinortho.tsv")

POGF_all$ID <- c(seq(1, nrow(POGF_all)))
colnames(POGF_all)[1] <- "A"
colnames(POGF_all)[2] <- "B"
colnames(POGF_all)[3] <- "C"
POGF_all_fin <- POGF_all %>% select(-(1:3))


write.table(POGF_all_fin, file = "ProteinOrthoTable.proteinortho.fill", sep = "\t", quote = FALSE, row.names = F, col.names = FALSE)
