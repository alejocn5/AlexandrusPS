library(dplyr)
#library(ggplot2)
library(caret)
library(reshape2)
#library(ggpubr)
#library(RColorBrewer)
library(stringr)
#library(viridis)
#library(ggpubr)
library(rstatix)



PositiveSelectionTable <- read.delim("./Final_table_positive_selection/PositiveSelectionTable.txt", header=FALSE, stringsAsFactors=FALSE)
colnames(PositiveSelectionTable) <- c("ID","Species","M0_lnL","M0_np", "M0_w","M1_lnL","M1_np", "M1_p0", "M1_p1", "M1_w0", "M1_w1", "M2_lnL","M2_np", "M3_lnL","M3_np","M7_lnL","M7_np", "M7_p","M7_q","M8_lnL","M8_np", "M8_p0", "M8_p","M8_q","M8_p1", "M8_w","M0_PSS","M1_PSS","M2_PSS","M3_PSS","M7_PSS","M8_PSS")
test <- PositiveSelectionTable %>% rowwise() %>%
  mutate(M0_M3_DoF=(M3_np-M0_np)) %>%
  mutate(M0_M3_LRT=2*(M3_lnL-M0_lnL)) %>%
  mutate(M1_M2_DoF=(M2_np-M1_np)) %>%
  mutate(M1_M2_LRT=2*(M2_lnL-M1_lnL)) %>%
  mutate(M7_M8_DoF=(M8_np-M7_np)) %>%
  mutate(M7_M8_LRT=2*(M8_lnL-M7_lnL)) %>%
  mutate(M0_M3_sig = pchisq(M0_M3_LRT, M0_M3_DoF, lower.tail=F)) %>%
  mutate(M1_M2_sig = pchisq(M1_M2_LRT, M1_M2_DoF, lower.tail=F)) %>%
  mutate(M7_M8_sig = pchisq(M7_M8_LRT, M7_M8_DoF, lower.tail=F)) #%>%
test <- adjust_pvalue(as.data.frame(test),p.col="M7_M8_sig",method="fdr")
test2 <- adjust_pvalue(as.data.frame(test),p.col="M1_M2_sig",method="fdr")

test  %>% mutate(stats=ifelse(M7_M8_sig.adj<0.05,"GUPS","noGUP")) %>% pull(stats) %>% table()
test2 %>% mutate(stats=ifelse(M1_M2_sig.adj<0.05,"GUPS","noGUP")) %>% pull(stats) %>% table()

Posprim <- test %>% filter(M7_M8_sig.adj < 0.05 & M8_w > 1)
PosprimM1_M2 <- test2 %>% filter(M1_M2_sig < 0.05 &  M1_w0 > 1)
write.table(Posprim %>% pull(ID),file="./Final_table_positive_selection/List_GUPS.txt", quote = F,row.names = F,col.names = F)
write.table(Posprim ,file="./Final_table_positive_selection/GenesUnderPositiveSelection.txt", quote = F,row.names = F,col.names = T)



