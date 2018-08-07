##   This is a an exercise in wrangling data provided from a pdf into RStudio and out to GitHub.
## The data was acquired online from RPubs.com at this url: 
## https://rpubs.com/elizajv/datawranging_exercise_1

##   I did not follow the exercise's wrangling procedure since I did not have the original file to manipulate.
## Instead I highlight-copied the printed data from that page, pasted it to a Google Doc. and saved the document as a pdf to my local repository.
## Afterwards I began to develop the code below.  The goal is to practice extracting and manipulating the data into a useable format.

library(readr)
library(pdftools)
library(stringr)

## The data extracted from the pdf (uploaded to GitHub as well) made two separate pages on several different lines.  I wanted to combine them.

raw_text <- pdf_text("./SpringBoard Workshop Ex 1/Springboard Workshop Ex 1.pdf")  
tab <- str_split(raw_text, "\n")
tab_1 <- tab[[1]][1:26]
tab_2a <- tab[[1]][27:37]
tab_2b <- tab[[2]]
tab_2 <- c(tab_2a, tab_2b)  

com_tab <- c(tab_1, tab_2) %>%
  str_replace_all("##\\s[0-9]+", "") %>%
  str_replace_all("##","") %>%
  str_trim()

## Extracted lines with column names

col_names_1 <- com_tab[1]
col_names_2 <- com_tab[27]

col_names_1 <- as.list(col_names_1) %>%
  str_trim() %>%
  str_split("\\s+", simplify = TRUE) %>%
  str_replace("Product.code...number", "product_code")

col_names_2 <- col_names_2 %>%
  str_trim() %>%
  str_split("\\s+", simplify=TRUE)

col_names <- c(col_names_1, col_names_2)

## Manipulated raw data 

raw_data_1 <- com_tab[2:26]
raw_data_2 <- com_tab[28:52]

raw_data_1 <- raw_data_1 %>%
  str_replace_all("\\s{3,}", " ") %>%
  str_replace_all("k z", "kz") %>%
  str_to_lower() %>%
  str_replace_all("van h", "van_h") %>%
  str_replace_all("akz0", "akzo") %>%
  str_replace_all("\\sg", "  G") %>%
  str_replace_all("\\sl", "  L") %>%
  str_replace_all("\\sd", "  D") %>%
  str_replace_all("\\sj", "  J") %>%
  str_replace_all("s\\s", "s  ") %>%
  str_replace_all("o\\s", "o  ") %>%
  str_replace_all("n\\s", "n  ") %>%
  str_replace_all("r\\s", "r  ") %>%
  str_replace_all("\\sarn", "  arn") %>%
  str_replace_all("^fi*l+i*|phi*l+i*", "phili") %>%
  str_replace_all("le*v", "lev") %>%
  str_split("\\s{2}", simplify = TRUE)
  
raw_data_2 <- raw_data_2 %>%
  str_replace_all("\\s{2,}", " ") %>%
  str_to_lower() %>%
  str_replace_all("the neth", "The_Neth") %>%
  str_replace_all("s\\s", "s  ")%>%
  str_split("\\s{2}", simplify = TRUE)

## Combined into a data frame

data <- data.frame(raw_data_1, raw_data_2) %>%
  setNames(col_names)
data
