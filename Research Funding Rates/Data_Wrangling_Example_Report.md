# Wrangling Exercise: PDF from the Web to RStudio

Introduction
------------

This is a report of how data was wrangled into RStudio from a table on a
PDF report from the internet. This excersize was a way for me to
practice data wrangling, report writing, and exporting to Github. The
wrangling of this exact table was already performed previously and
exists in the 'dslabs' library in RStudio under
"research\_funding\_rates". I used this to test for accuracy of this
code. See the end of the report.

Here is the link to the research funding rates report (known as the PDF
moving forward) used at the time of this writing:
<http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf>.

I loaded the following:

    library(pdftools)
    library(stringr)
    library(dplyr)
    library(readr)

### Pulling Text from the PDF

First the PDF was downloaded from the URL into a temporary file. The
text data was extracted into RStudio and saved to an object 'txt'. Then
the temporary file was removed.

    temp_file <- tempfile()
    url <- "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
    download.file(url, temp_file, mode = "wb")
    txt <- pdf_text(temp_file)
    file.remove(temp_file)

    ## [1] TRUE

The 'txt' object created above contains all the text information from
the entire PDF. Only the data from the table on the second page of the
PDF is needed for my scope of work.

    raw_data_research_funding_rates <- txt[2]

### Wrangle Data into a List then Extract Column Names

    tab <- str_split(raw_data_research_funding_rates, "\n")
    tab <- tab[[1]]
    the_names_1 <- tab[3]
    the_names_2 <- tab[4]

### Trim and Condense Column Names and Values

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

Conclusion
----------

The 'dslabs' library in RStudio has this data frame already. This
wrangling excersize was a way for me to practice report writing and
uploading to Github. The below should be true to test for an accurate
list:

    library(dslabs)
    data("research_funding_rates")
    identical(research_funding_rates, new_research_funding_rates)

    ## [1] TRUE

When I ran this code, the two objects were identical indicating success.
Here is the list:

    print(new_research_funding_rates)

    ##            discipline applications_total applications_men
    ## 1   Chemical sciences                122               83
    ## 2   Physical sciences                174              135
    ## 3             Physics                 76               67
    ## 4          Humanities                396              230
    ## 5  Technical sciences                251              189
    ## 6   Interdisciplinary                183              105
    ## 7 Earth/life sciences                282              156
    ## 8     Social sciences                834              425
    ## 9    Medical sciences                505              245
    ##   applications_women awards_total awards_men awards_women
    ## 1                 39           32         22           10
    ## 2                 39           35         26            9
    ## 3                  9           20         18            2
    ## 4                166           65         33           32
    ## 5                 62           43         30           13
    ## 6                 78           29         12           17
    ## 7                126           56         38           18
    ## 8                409          112         65           47
    ## 9                260           75         46           29
    ##   success_rates_total success_rates_men success_rates_women
    ## 1                26.2              26.5                25.6
    ## 2                20.1              19.3                23.1
    ## 3                26.3              26.9                22.2
    ## 4                16.4              14.3                19.3
    ## 5                17.1              15.9                21.0
    ## 6                15.8              11.4                21.8
    ## 7                19.9              24.4                14.3
    ## 8                13.4              15.3                11.5
    ## 9                14.9              18.8                11.2
