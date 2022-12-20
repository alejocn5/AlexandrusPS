library(dplyr)
library(ggplot2)
library(caret)
library(reshape2)
library(ggpubr)
library(RColorBrewer)
library(stringr)
library(viridis)
library(ggpubr)
library(rstatix)

####Branch####
Branch_models_Table <- read.delim("./Final_table_positive_selection/Branch_models_BranchSite_models_Table.txt", header=FALSE, stringsAsFactors=TRUE)
colnames(Branch_models_Table) <- c("ID","SP","M0_lnL","M0_np", "bsM0_lnL",	"bsM0_np",	"bsM0H0_lnL", "bsM0H0_np",	"bsM0H1_lnL",	"bsM0H1_np")

BS_analysis <- Branch_models_Table %>% rowwise() %>%
  mutate(M0_bM0_DoF=(bsM0_np-M0_np)) %>%
  mutate(M0_bM0_LRT=2*(bsM0_lnL-M0_lnL)) %>%
  mutate(bsM0H1_bsM0H0_DoF=(bsM0H1_np-bsM0H0_np)) %>%
  mutate(bsM0H1_bsM0H0_LRT=2*(bsM0H1_lnL-bsM0H0_lnL)) %>%
  mutate(M0_bM0_sig = pchisq(M0_bM0_LRT, M0_bM0_DoF, lower.tail=F)) %>%
  mutate(bsM0H1_bsM0H0_sig = pchisq(bsM0H1_bsM0H0_LRT, bsM0H1_bsM0H0_DoF, lower.tail=F)) #%>%
Branch_model <- adjust_pvalue(as.data.frame(BS_analysis),p.col="M0_bM0_sig",method="fdr")
Branch_site <- adjust_pvalue(as.data.frame(BS_analysis),p.col="bsM0H1_bsM0H0_sig",method="fdr")

Branch_model <-Branch_model %>% filter(M0_bM0_sig.adj < 0.05)
Branch_site <- Branch_site %>% filter(bsM0H1_bsM0H0_sig.adj < 0.05)

#Branch_site %>% rowwise() %>%
#  mutate(ID=unlist(strsplit(ID,split="_"))[2]) %>% pull(ID)


write.table(Branch_model ,file="./Final_table_positive_selection/Branch_model.txt", quote = F,row.names = F,col.names = T)
write.table(Branch_site ,file="./Final_table_positive_selection/Branch_site_model.txt", quote = F,row.names = F,col.names = T)
#write.table(Branch_model %>% rowwise() %>% mutate(ID=unlist(strsplit(ID,split="_"))[2]) %>% pull(ID),file="./Final_table_positive_selection/Branch_model_ID.txt", quote = F,row.names = F,col.names = F)
#write.table(Branch_site %>% rowwise() %>% mutate(ID=unlist(strsplit(ID,split="_"))[2]) %>% pull(ID),file="./Final_table_positive_selection/Branch_site_model_ID.txt", quote = F,row.names = F,col.names = F)

#write.table(Branch_model %>% pull(ID),file="./Final_table_positive_selection/Branch_model.txt", quote = F,row.names = F,col.names = F)
#write.table(Branch_site %>% pull(ID),file="./Final_table_positive_selection/Branch_site_model.txt", quote = F,row.names = F,col.names = F)
