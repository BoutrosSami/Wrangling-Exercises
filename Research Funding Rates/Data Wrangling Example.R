library(pdftools)
library(stringr)
library(dplyr)
library(readr)

## PDF downloaded from URL, data extraction, and file removed

temp_file <- tempfile()
url <- "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
download.file(url, temp_file, mode = "wb")
txt <- pdf_text(temp_file)
file.remove(temp_file)

## "txt" object contains the text and the data.  We are only interested in the data for the scope of this report. 

raw_data_research_funding_rates <- txt[2]

## Wrangle data into a list and extract column names.

tab <- str_split(raw_data_research_funding_rates, "\n")
tab <- tab[[1]]
the_names_1 <- tab[3]
the_names_2 <- tab[4]

## Trim and condense column names and values.

the_names_1 <- the_names_1 %>%
  str_trim() %>%
  str_replace_all(",\\s.", "") %>%
  str_split("\\s{2,}", simplify = TRUE)
the_names_2 <- the_names_2 %>%
  str_trim() %>%
  str_split("\\s+", simplify = TRUE)
tmp_names <- str_c(rep(the_names_1, each = 3), the_names_2[-1], sep = "_")
the_names <- c(the_names_2[1], tmp_names) %>%
  str_to_lower() %>%
  str_replace_all("\\s", "_")
new_research_funding_rates <- tab[6:14] %>%
  str_trim() %>%
  str_split("\\s{2,}", simplify = TRUE) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  setNames(the_names) %>%
  mutate_at(-1, parse_number)


## The below should be true to test for an accurate data frame:

library(dslabs)
data("research_funding_rates")
identical(research_funding_rates, new_research_funding_rates)