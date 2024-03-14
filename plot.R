library(tidyverse)
library(ggsignif)


file <- '103&117/Combined_results_117_tpex.csv'



data <- read_csv(file )
data$group <- unlist(lapply(data$`File name`, function(x) strsplit(strsplit(x,'_')[[1]][3],'.czi')[[1]][1]))

Tpex <- 'Num CD3+: CD8+: PD1+: TCF1+' 
Tex <- 'Num CD3+: CD8+: PD1+: TCF1-'

all <-'Num Detections'

order = unique(data$group)






  

data[,'Tpex']<- data[,Tpex]/data[,all]*100

data[,'Tex']<- data[,Tex]/data[,all]*100

data[,'Tratio'] <- (data[,Tpex]+1)/(data[,Tex]+1)*100

data[is.na(data)]=0


plot <- ggplot(data,aes(x=group,y=Tpex))+
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(width = 0.1)+
  geom_signif(comparisons=combn(unique(data$group),2,simplify=F),
              position='jitter')

plot <- ggplot(data,aes(x=group,y=Tex))+
  geom_boxplot()

plot <- ggplot(data,aes(x=group,y=Tratio))+
  geom_boxplot()




## Tpex
key='Tpex'


## remove outliers for each group

for (samples in unique(data$group)){
  file_loca = which(data$group == samples)
  col <- as.numeric(unlist(data[file_loca,key]))
  z <- which(col %in% boxplot.stats(col)$out)
  if (length(z) != 0 ){
    data <-  data[-file_loca[z],]}}

data$group <- factor(data$group,levels = c('Ctrl','Abx+iso','Abx+PD1') )








iso_data <- data[-grep('PD1',data$group),]

Tpex_Means <- iso_data%>%
  group_by(group)%>%
  summarise(means = mean(Tpex), 
            sd=sd(Tpex),
            N_N=n(), 
            se=sd/sqrt(N_N),
            upper_limit=means+se, 
            lower_limit=means-se 
  ) %>% as.data.frame()

colnames(Tpex_Means)[2] <- 'Tpex'



plot<- ggplot(iso_data,aes(x=group,y= Tpex,fill=group,color=group))+
  theme_set(theme_classic())+
  theme(plot.margin=unit(c(1,1,1,1),"cm"))+
  
  labs(x = 'Treatment'  , y = 'Tpex cell percentage %')+
  
  geom_violin(data=iso_data,trim=F,scale='width',width = 0.55,size=0.15,alpha=1/3,color='white')+
  scale_fill_manual(values=c('black','#008000'))+
  
  #geom_boxplot(outlier.shape = NA)+
  #coord_cartesian(ylim = ylim1*1.05)+
  #theme(legend.position="none")+
  theme(legend.position="bottom")+
  #guides(fill=guide_legend(nrow=2, byrow=TRUE,size=0.1))+
  
  
  scale_color_manual(values=c('black','#008000'))+
  
  geom_point(position = position_jitter(w = 0.07),size=1.1,shape=16,alpha=5/10)+
  #geom_point(data= Means,aes(x= Treatment, y = `percentage %`), size=5, shape='-', color='black')+
  geom_signif(comparisons=list(as.character(unique(iso_data$group))),map_signif_level=F,color='black',test = "wilcox.test",tip_length = 0.02, size = 01, textsize = 2)+
  geom_errorbar(data = Tpex_Means,aes(ymin=lower_limit, ymax=upper_limit),color='black',width=.05,size=0.5,alpha=7/10)+
  geom_errorbar(data = Tpex_Means, aes(ymax=Tpex, ymin=Tpex),width=.35,size=0.65,color='black') 

theme(plot.title = element_text(size = 5, face = "bold",,hjust = 0.4, vjust = 8))+
  theme(axis.text.x = element_text(angle = 45,size = 5,vjust=1,hjust=1))


legend <- cowplot::get_legend(plot)

plot <- plot+theme(legend.position="none")

ggsave(paste(strsplit(file,'.csv')[[1]][1],'_iso_Tpex_legend.pdf',sep=''),legend)
ggsave(paste(strsplit(file,'.csv')[[1]][1],'_iso_Tpex_.pdf',sep=''),plot,width=4, height=5)

#########################################



PD1_data <- data[grep('PD1',data$group),]

Tpex_Means <- PD1_data%>%
  group_by(group)%>%
  summarise(means = mean(Tpex), 
            sd=sd(Tpex),
            N_N=n(), 
            se=sd/sqrt(N_N),
            upper_limit=means+se, 
            lower_limit=means-se 
  ) %>% as.data.frame()

colnames(Tpex_Means)[2] <- 'Tpex'

plot<- ggplot(PD1_data,aes(x=group,y= Tpex,fill=group,color=group))+
  theme_set(theme_classic())+
  theme(plot.margin=unit(c(1,1,1,1),"cm"))+
  
  labs(x = 'Treatment'  , y = 'Tpex cell percentage %')+
  
  geom_violin(data=PD1_data,trim=F,scale='width',width = 0.55,size=0.15,alpha=1/3,color='white')+
  scale_fill_manual(values=c('black','#008000'))+
  
  #geom_boxplot(outlier.shape = NA)+
  #coord_cartesian(ylim = ylim1*1.05)+
  #theme(legend.position="none")+
  theme(legend.position="bottom")+
  #guides(fill=guide_legend(nrow=2, byrow=TRUE,size=0.1))+
  
  
  scale_color_manual(values=c('black','#008000'))+
  
  geom_point(position = position_jitter(w = 0.07),size=1.1,shape=16,alpha=5/10)+
  #geom_point(data= Means,aes(x= Treatment, y = `percentage %`), size=5, shape='-', color='black')+
  geom_signif(comparisons=list(as.character(unique(PD1_data$group))),map_signif_level=F,color='black',test = "wilcox.test",tip_length = 0.02, size = 01, textsize = 2)+
  geom_errorbar(data = Tpex_Means,aes(ymin=lower_limit, ymax=upper_limit),color='black',width=.05,size=0.5,alpha=7/10)+
  geom_errorbar(data = Tpex_Means, aes(ymax=Tpex, ymin=Tpex),width=.35,size=0.65,color='black') 

theme(plot.title = element_text(size = 5, face = "bold",,hjust = 0.4, vjust = 8))+
  theme(axis.text.x = element_text(angle = 45,size = 5,vjust=1,hjust=1))


legend <- cowplot::get_legend(plot)

plot <- plot+theme(legend.position="none")

ggsave(paste(strsplit(file,'.csv')[[1]][1],'_PD1_Tpex_legend.pdf',sep=''),legend)
ggsave(paste(strsplit(file,'.csv')[[1]][1],'_PD1_Tpex_.pdf',sep=''),plot,width=4, height=5)







ABX_data <- data[grep('abx',data$group,ignore.case = T),]

Tpex_Means <- ABX_data%>%
  group_by(group)%>%
  summarise(means = mean(Tpex), 
            sd=sd(Tpex),
            N_N=n(), 
            se=sd/sqrt(N_N),
            upper_limit=means+se, 
            lower_limit=means-se 
  ) %>% as.data.frame()

colnames(Tpex_Means)[2] <- 'Tpex'

plot<- ggplot(ABX_data,aes(x=group,y= Tpex,fill=group,color=group))+
  theme_set(theme_classic())+
  theme(plot.margin=unit(c(1,1,1,1),"cm"))+
  
  labs(x = 'Treatment'  , y = 'Tpex cell percentage %')+
  
  geom_violin(data=ABX_data,trim=F,scale='width',width = 0.55,size=0.15,alpha=1/3,color='white')+
  scale_fill_manual(values=c('black','#008000'))+
  
  #geom_boxplot(outlier.shape = NA)+
  #coord_cartesian(ylim = ylim1*1.05)+
  #theme(legend.position="none")+
  theme(legend.position="bottom")+
  #guides(fill=guide_legend(nrow=2, byrow=TRUE,size=0.1))+
  
  
  scale_color_manual(values=c('black','#008000'))+
  
  geom_point(position = position_jitter(w = 0.07),size=1.1,shape=16,alpha=5/10)+
  #geom_point(data= Means,aes(x= Treatment, y = `percentage %`), size=5, shape='-', color='black')+
  geom_signif(comparisons=list(as.character(unique(ABX_data$group))),map_signif_level=F,color='black',test = "wilcox.test",tip_length = 0.02, size = 01, textsize = 2)+
  geom_errorbar(data = Tpex_Means,aes(ymin=lower_limit, ymax=upper_limit),color='black',width=.05,size=0.5,alpha=7/10)+
  geom_errorbar(data = Tpex_Means, aes(ymax=Tpex, ymin=Tpex),width=.35,size=0.65,color='black') 

theme(plot.title = element_text(size = 5, face = "bold",,hjust = 0.4, vjust = 8))+
  theme(axis.text.x = element_text(angle = 45,size = 5,vjust=1,hjust=1))


legend <- cowplot::get_legend(plot)

plot <- plot+theme(legend.position="none")

ggsave(paste(strsplit(file,'.csv')[[1]][1],'_ABX_Tpex_legend.pdf',sep=''),legend)
ggsave(paste(strsplit(file,'.csv')[[1]][1],'_ABX_Tpex_.pdf',sep=''),plot,width=4, height=5)





CTRL_data <- data[grep('CTRL',data$group,ignore.case = T),]

Tpex_Means <- CTRL_data%>%
  group_by(group)%>%
  summarise(means = mean(Tpex), 
            sd=sd(Tpex),
            N_N=n(), 
            se=sd/sqrt(N_N),
            upper_limit=means+se, 
            lower_limit=means-se 
  ) %>% as.data.frame()

colnames(Tpex_Means)[2] <- 'Tpex'

plot<- ggplot(CTRL_data,aes(x=group,y= Tpex,fill=group,color=group))+
  theme_set(theme_classic())+
  theme(plot.margin=unit(c(1,1,1,1),"cm"))+
  
  labs(x = 'Treatment'  , y = 'Tpex cell percentage %')+
  
  geom_violin(data=CTRL_data,trim=F,scale='width',width = 0.55,size=0.15,alpha=1/3,color='white')+
  scale_fill_manual(values=c('black','#008000'))+
  
  #geom_boxplot(outlier.shape = NA)+
  #coord_cartesian(ylim = ylim1*1.05)+
  #theme(legend.position="none")+
  theme(legend.position="bottom")+
  #guides(fill=guide_legend(nrow=2, byrow=TRUE,size=0.1))+
  
  
  scale_color_manual(values=c('black','#008000'))+
  
  geom_point(position = position_jitter(w = 0.07),size=1.1,shape=16,alpha=5/10)+
  #geom_point(data= Means,aes(x= Treatment, y = `percentage %`), size=5, shape='-', color='black')+
  geom_signif(comparisons=list(as.character(unique(CTRL_data$group))),map_signif_level=F,color='black',test = "wilcox.test",tip_length = 0.02, size = 01, textsize = 2)+
  geom_errorbar(data = Tpex_Means,aes(ymin=lower_limit, ymax=upper_limit),color='black',width=.05,size=0.5,alpha=7/10)+
  geom_errorbar(data = Tpex_Means, aes(ymax=Tpex, ymin=Tpex),width=.35,size=0.65,color='black') 

theme(plot.title = element_text(size = 5, face = "bold",,hjust = 0.4, vjust = 8))+
  theme(axis.text.x = element_text(angle = 45,size = 5,vjust=1,hjust=1))


legend <- cowplot::get_legend(plot)

plot <- plot+theme(legend.position="none")

ggsave(paste(strsplit(file,'.csv')[[1]][1],'_CTRL_Tpex_legend.pdf',sep=''),legend)
ggsave(paste(strsplit(file,'.csv')[[1]][1],'_CTRL_Tpex_.pdf',sep=''),plot,width=4, height=5)





file <- '122B.csv'

order = c('SPF','GF')


data <- read_csv(file)

Tpex <- 'Num CD3+: PD1+: TCF1+: CD8+'

Tpex_cd3_N <- 'Num CD3-: PD1+: TCF1+: CD8+'

Tex <- 'Num CD3+: PD1+: TCF1-: CD8+'

all <-'Num Detections'







data$group <- unlist(lapply(data$`File name`, function(x) strsplit(strsplit(x,'_')[[1]][3],'.czi')[[1]][1]))

data[is.na(data)]=0


data[,'Tpex']<- (data[,Tpex ]+data[,Tpex_cd3_N ])/data[,all]*100

data[,'Tex']<- data[,Tex]/data[,all]*100

data[,'Tratio'] <- (data[,Tpex]+1)/(data[,Tex]+1)*100






plot <- ggplot(data,aes(x=group,y=Tpex))+
  geom_boxplot(outlier.shape = NA)+
  geom_point()

plot <- ggplot(data,aes(x=group,y=Tex))+
  geom_boxplot()

plot <- ggplot(data,aes(x=group,y=Tratio))+
  geom_boxplot()




## Tpex
key='Tpex'


## remove outliers for each group

for (samples in unique(data$group)){
  file_loca = which(data$group == samples)
  col <- as.numeric(unlist(data[file_loca,key]))
  z <- which(col %in% boxplot.stats(col)$out)
  if (length(z) != 0 ){
    data <-  data[-file_loca[z],]}}

data$group <- factor(data$group,levels = order)

Tpex_Means <- data%>%
  group_by(group)%>%
  summarise(means = mean(Tpex), 
            sd=sd(Tpex),
            N_N=n(), 
            se=sd/sqrt(N_N),
            upper_limit=means+se, 
            lower_limit=means-se 
  ) %>% as.data.frame()

colnames(Tpex_Means)[2] <- 'Tpex'

plot<- ggplot(data,aes(x=group,y= Tpex,fill=group,color=group))+
  theme_set(theme_classic())+
  theme(plot.margin=unit(c(1,1,1,1),"cm"))+
  
  labs(x = 'Treatment'  , y = 'Tpex cell percentage %')+
  
  geom_violin(data=data,trim=F,scale='width',width = 0.55,size=0.15,alpha=1/3,color='white')+
  scale_fill_manual(values=c('black','#008000'))+
  
  #geom_boxplot(outlier.shape = NA)+
  #coord_cartesian(ylim = ylim1*1.05)+
  #theme(legend.position="none")+
  theme(legend.position="bottom")+
  #guides(fill=guide_legend(nrow=2, byrow=TRUE,size=0.1))+
  
  
  #scale_color_manual(values=c('black','#008000'))+
  
  geom_point(position = position_jitter(w = 0.07),size=1.1,shape=16,alpha=5/10)+
  #geom_point(data= Means,aes(x= Treatment, y = `percentage %`), size=5, shape='-', color='black')+
  #geom_signif(comparisons=list(as.character(unique(data$group))),map_signif_level=F,color='black',test = "wilcox.test",tip_length = 0.02, size = 01, textsize = 2)+
  geom_errorbar(data = Tpex_Means,aes(ymin=lower_limit, ymax=upper_limit),color='black',width=.05,size=0.5,alpha=7/10)+
  geom_errorbar(data = Tpex_Means, aes(ymax=Tpex, ymin=Tpex),width=.35,size=0.65,color='black') 

  theme(plot.title = element_text(size = 5, face = "bold",,hjust = 0.4, vjust = 8))+
  theme(axis.text.x = element_text(angle = 45,size = 5,vjust=1,hjust=1))



legend <- cowplot::get_legend(plot)

plot <- plot+theme(legend.position="none")




ggsave(paste(strsplit(file,'.csv')[[1]][1],'Tpex_legend.pdf',sep=''),legend)
ggsave(paste(strsplit(file,'.csv')[[1]][1],'.pdf',sep=''),plot,width=4, height=5)



