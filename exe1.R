library(readxl,quietly = TRUE)
library(dplyr,quietly = TRUE)
library(tidyr, quietly = TRUE)
library(WriteXLS, quietly = TRUE)

#Remove previous any previous objects
remove(refine)

#Load Data into Data Frame
refine <- read_xlsx("refine_original.xlsx")

#TASK 1 - Clean up company name values to standard lowercase values
refine$company <- tolower(refine$company)
refine$company <- ifelse(refine$company == "phillips", "philips",
                         ifelse(refine$company == "phllips", "philips",
                                ifelse(refine$company == "philips", "philips",
                                       ifelse(refine$company == "phillps","philips",
                                              ifelse(refine$company == "fillips", "philips",
                                                     ifelse(refine$company == 'phlips',"philips", refine$company))))))
refine$company <- ifelse(refine$company == "akz0", "akzo",
                         ifelse(refine$company == "ak zo", "akzo", refine$company))

refine$company <- ifelse(refine$company == "unilver","unilever",refine$company)

#TASK 2 - Seperate Product Code and Number
refine <- refine %>% separate(`Product code / number`, sep = "-", c("Product Code", "Product Number"))

#TASK 3 - Add column Product Category based of Product Code value
category <- ifelse(refine$`Product Code` == 'p', "Smartphone", 
       ifelse (refine$`Product Code` == 'v', "TV",
               ifelse(refine$`Product Code`=='x', "Laptop",
                      ifelse(refine$`Product Code`=='q', "Tablet",0))))
refine <- cbind(refine, "product category" = category)

#TASK 4 - Create Full Address column by joing address, city & country
refine <- cbind(refine, "Full Address" = paste(refine$address,refine$city,refine$country, sep = ","))


#TASK 5 - Binary Columns
refine <- cbind(refine,"company_philips" = ifelse(refine$company=='philips',1,0),
      "company_akzo" = ifelse(refine$company=='akzo',1,0), 
      "company_van_houten" = ifelse(refine$company=='van houten',1,0),
      "company_unilever" = ifelse(refine$company=='unilever',1,0))

WriteXLS(refine, ExcelFileName = "refine_clean.xlsx")


