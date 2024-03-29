tmp<-readRDS('/project/CRI/DeBerardinis_lab/lcai/NSCLC_Metabolism/scripts/final/data/metabolic_profiling_data.rds')
tmp<-tmp[which(rownames(tmp)!='H446'),]
library(Hmisc)
tmp.cor<-rcorr(as.matrix(tmp))
library(reshape2)
tmp.flat<-data.frame(melt(tmp.cor$r),melt(tmp.cor$P))
tmp.flat<-tmp.flat[tmp.flat[,6]<0.05,]
min(abs(na.omit(tmp.flat[,3])))
library(openxlsx)
hs1 <- createStyle(fgFill = "#DD4714", halign = "CENTER", textDecoration = "Bold",
                   border = "Bottom", fontColour = "white")
wb<-createWorkbook()
addWorksheet(wb,'Pearson_r')
writeDataTable(wb,'Pearson_r',data.frame("feature"=colnames(tmp),round(tmp.cor$r,2),check.names = F),rowNames = F,headerStyle = hs1)
addWorksheet(wb,'Pearson_pv')
writeDataTable(wb,'Pearson_pv',data.frame("feature"=colnames(tmp),signif(tmp.cor$P,2),check.names = F),rowNames = F,headerStyle = hs1)
saveWorkbook(wb,'correlations.xlsx',overwrite = T)

wb<-createWorkbook()
addWorksheet(wb,'data')
writeDataTable(wb,'data',data.frame("Cell Line"=rownames(tmp),tmp,check.names = F),rowNames = F,headerStyle = hs1)
saveWorkbook(wb,'NSCLC_metabolic_profiling.xlsx',overwrite = T)
