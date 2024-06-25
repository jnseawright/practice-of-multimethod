library(tidyverse) # for everything really
library(pdftools)  # to get text from PDFs
library(quanteda)  # to extract window around our word
library(glue)      # for string interpolation when making filenames for OCR
library(tesseract) # to OCR two-column and otherwise problematic articles
library(magick)    # for slightly faster pdf-image conversion
library(tictoc)    # for timekeeping during testing
library(extrafont) # for importing PDF texts correctly

if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("trinker/textreadr")

#library(corpus)

setwd("/media/jws780/ExpansionSpace/backsliding/Articles")


# try a combination -------------------------------------------------------


# create list of articles with filename and 
# other relevant information
files <- read.csv("/home/jws780/Documents/GitHub/practice-of-multimethod/backsliding/files.csv")

source("/home/jws780/OneDrive/Seawright Research/Comparative Support for Extremism/Extremism Articles/patterns_fulltext.R")

# create dataframe
db <- data.frame(filename = files$filename,
                 author1discipline = files$author1discipline, 
                 journal = files$journal, 
                 year = files$year,
                 author1name = files$author1name, 
                 citationcount = files$citationcount, 
                 journalhindex = files$journalhindex, 
                 doiurl = files$doiurl, 
                 text = NA,
                 twocol = 0,
                 notes = "none")

# read in all articles with 1 column layout

for (i in 1:nrow(db)) {

  tryCatch(
    
    expr = {
      
      if(!db$twocol[i]){ 
        extracted_text <- pdftools::pdf_text(db$filename[i])
        extracted_text <- paste0(extracted_text, collapse = ' ')
        db$text[i] <- extracted_text
        db$notes[i] <- "parsed successfully using pdftools" # in case any others errors show up
        print(paste0("done with ", i, "/", nrow(db), ". ", db$filename[i]))
      }else{
        print(paste0("two-col journal", db$filename[i])) 
      }
    }, error = function (e) {
      #db$notes[i] <- "error" # this somehow doesn't work, sadly
      print(paste0("problem with index:", i, ",",  db$filename[i] ))
      
    }, finally = {
    }
  )
  

}

testbiblocations <- vector("numeric",length(db$text))
#testbiblocations <- rep(NA,length(db$text))


dbnocite <- db


for (i in 1:length(db$text)){
  biblocation <- coalesce(str_locate(db$text[i],"References")[1], 
                          str_locate(db$text[i],"Works Cited")[1], 
                          str_locate(db$text[i],"Bibliography")[1], 
                          str_locate(db$text[i],"Literature Cited")[1],
                          str_locate(db$text[i],"LITERATURE CITED")[1],
                          str_locate(db$text[i],"Sources and further information")[1],
                          str_locate(db$text[i],"REFERENCES")[1], 
                          str_locate(db$text[i],"WORKS CITED")[1], 
                          str_locate(db$text[i],"BIBLIOGRAPHY")[1], 
                          str_locate(db$text[i],"NOTES")[1],
                          str_locate(db$text[i],"Notes")[1])
  testbiblocations[i]<-biblocation
  
  if (!is.na(biblocation) & biblocation < .34*length(db$text)){
    trunctext <- substr(db$text,round(.34*length(db$text)),length(db$text))
    biblocation <- round(.34*length(db$text)) + coalesce(str_locate(trunctext,"References")[1], 
                                                         str_locate(trunctext,"Works Cited")[1], 
                                                         str_locate(trunctext,"Bibliography")[1], 
                                                         str_locate(trunctext,"Literature Cited")[1],
                                                         str_locate(trunctext,"LITERATURE CITED")[1],
                                                         str_locate(trunctext,"Sources and further information")[1],
                                                         str_locate(trunctext,"REFERENCES")[1], 
                                                         str_locate(trunctext,"WORKS CITED")[1], 
                                                         str_locate(trunctext,"BIBLIOGRAPHY")[1], 
                                                         str_locate(trunctext,"NOTES")[1],
                                                         str_locate(trunctext,"Notes")[1])
    testbiblocations[i]<-biblocation
  }
  
  if (!is.na(biblocation)){
    dbnocite$text[i] <- str_trunc(dbnocite$text[i], biblocation, "right")}
}

for (i in 1:nrow(dbnocite)){
  dbnocite$text[i] <- str_sub(dbnocite$text[i],500,nchar(dbnocite$text[i]))
}

db_nodownload <- dbnocite %>% 
  # Bulk of Removals
  mutate(text = str_remove_all(text, pattern = pattern_sum)) %>%
  # weird jstor extras
  mutate(text = str_remove_all(text, pattern = pattern_jstor_3)) %>% 
  
  # Individual string that works -- the other ones IDed in the 
  # text windows don't hit here, likely because of differences in 
  # spaces/line breaks
  
  mutate(text = str_remove_all(text, pattern = fixed(patterns_unique_6))) %>% 
  
  # Those that are left at the end of the string because they are truncated
  # should not really work here -- check for false positives
  
  mutate(text = str_remove_all(text, pattern = "(Downloaded from).*?$")) %>%
  mutate(text = str_remove_all(text, pattern = "(This content downloaded from).*?$")) %>%
  mutate(text = str_remove_all(text, pattern = "(Downloaded by \\[).*?$")) %>%
  mutate(text = str_remove_all(text, pattern = "(https \\[).*?$")) %>%
  mutate(text = str_remove_all(text, pattern = "(doi \\[).*?$")) %>%
  mutate(text = str_remove_all(text, pattern = "(hein \\[).*?$")) 
  

window_size = 100L

# it wouldn't let me do the corpus without replacing empty text NA with ""
db_nodownload$text[is.na(db_nodownload$text)] <- ""

# create corpus from our dataset
corp <- corpus(db_nodownload, 
               text_field = "text", 
               docid_field = "filename",
               meta = c("filename","journal","author1name","author1discipline","citationcount","journalhindex","year","doiurl"),  
)  

# tokenize, and use keywords-in context function
x <- tokens(corp, 
            #remove_punct = TRUE
) %>%
  kwic("*backslid*", window = window_size) %>% 
  as.data.frame()

final_db <- dbnocite %>% 
  dplyr::select(-text) %>% 
  left_join(x, by=c("filename" = "docname"))

library(stm)
library(tm)

final_db$full.backsliding.text <- paste(final_db$pre,final_db$keyword,final_db$post,sep=" ")

dbtowrite <- final_db[,c(1:7,17)]

processed_backsliding <- textProcessor(documents=final_db$full.backsliding.text, 
                                     metadata=final_db)

prep_backsliding <- prepDocuments(processed_backsliding$documents, processed_backsliding$vocab, processed_backsliding$meta)

backsliding.stm <- stm(prep_backsliding$documents, prep_backsliding$vocab, 5, 
                     prevalence=~citationcount+year, data=prep_backsliding$meta)


testmodelsize<-searchK(prep_backsliding$documents, prep_backsliding$vocab, K = c(3,5,7,9,11,13,15), 
                       prevalence=~ citationcount+year, data=prep_backsliding$meta, verbose=FALSE)

plot(testmodelsize)

labelTopics(backsliding.stm)


