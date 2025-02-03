# This section is just installing a package and importing the data
packages<-installed.packages()
needed_packages<-c('labelled', 'googlesheets4')

needed_packages<-needed_packages[which(needed_packages%in%packages[,1] == FALSE)]
for(i in needed_packages){
  install.packages(needed_packages)
}
library(googlesheets4)
library(labelled)
url<-'https://docs.google.com/spreadsheets/d/1ThOq7SQjnOQxvdbzUawE5jo5UwOyoSSDxDcPMec5C8Q/edit?gid=518794249#gid=518794249'
responses<-read_sheet(url, sheet='Responses')
newnames<-read_sheet(url, sheet='names')
colnames(responses) <- newnames$colname


for(i in colnames(responses)){
  index<-which(newnames$colname==i)
  if(!is.na(newnames$labels[index])){
    labels<-eval(parse(text=newnames$labels[index]))
    responses[[i]] <- factor(responses[[i]], levels=labels)
    
  }
  
}

# adding labels
var_label(responses) <- newnames$label


saveRDS(responses, file='responses.rds')

rm(list= ls())
