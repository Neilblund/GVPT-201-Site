# This section is just installing a package and importing the data
packages<-installed.packages()

if(!'googlesheets4' %in% packages[,1]){
  install.packages('googlesheets4')
}
library(googlesheets4)
url<-'https://docs.google.com/spreadsheets/d/1ThOq7SQjnOQxvdbzUawE5jo5UwOyoSSDxDcPMec5C8Q/edit?gid=518794249#gid=518794249'
responses<-read_sheet(url, sheet='Responses')
newnames<-read_sheet(url, sheet='names')
colnames(responses) <- newnames$colname
# adding labels
for(i in colnames(responses)){
  index<-which(newnames$colname==i)
  labs<-newnames$label[index]
  responses[[i]] <- haven::labelled(responses[[i]], 
                                    label=labs)
  if(!is.na(newnames$labels[index])){
    labels<-eval(parse(text=newnames$labels[index]))
    responses[[i]] <- factor(responses[[i]], levels=labels)
    
  }else{
    responses[[i]] <- haven::labelled(responses[[i]], 
                                      label=labs)
  }
  
  
}

saveRDS(responses, file='responses.rds')

rm(list= ls())
