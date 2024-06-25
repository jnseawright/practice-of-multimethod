library(tidyverse) # for everything really
library(stm)
library(tm)

backsliding_texts <- read.csv("/home/jws780/Documents/GitHub/practice-of-multimethod/backsliding/backslidingtexts.csv")

processed_backsliding <- textProcessor(documents=backsliding_texts$full.backsliding.text, 
                                     metadata=backsliding_texts)

prep_backsliding <- prepDocuments(processed_backsliding$documents, processed_backsliding$vocab, processed_backsliding$meta)

backsliding.stm <- stm(prep_backsliding$documents, prep_backsliding$vocab, 5, 
                     prevalence=~citationcount+year, data=prep_backsliding$meta)


testmodelsize<-searchK(prep_backsliding$documents, prep_backsliding$vocab, K = c(5,7,9,11,13,15), 
                       prevalence=~ citationcount+year, data=prep_backsliding$meta, verbose=FALSE)

plot(testmodelsize)

labelTopics(backsliding.stm)


