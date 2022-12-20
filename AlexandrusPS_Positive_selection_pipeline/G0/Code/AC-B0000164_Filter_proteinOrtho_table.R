library(dplyr)
library(ggplot2)
library(caret)
library(reshape2)
library(ggpubr)
library(RColorBrewer)
library(stringr)
library(viridis)
library(ggpubr)


POGF_all <- read.delim("./AC-B0000163_POGF_all.proteinortho")
POGF_all$ID<-c(seq(1, nrow(POGF_all)))
POGF_all <- POGF_all[,c(4:11,14:18)]
write.table(POGF_all, file = "AC-B0000163_POGF_all.proteinortho.fill", sep = "\t", quote = FALSE, row.names = F)


