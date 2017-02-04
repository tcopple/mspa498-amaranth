##This is an example eda file using the rda design files. In this script we'll load the 2011
##data and then output the frequency tables for two variables medcost and physhlth

library(survey)
library(MonetDBLite)
library(DBI)
library(stringr)

year = 2014
rdaFileName = paste0("./design-rda/b", year, "design.rda")
load(rdaFileName)

dbfolder = paste0( getwd() , "/MonetDB" )
db = dbConnect(MonetDBLite::MonetDBLite() , dbfolder)

variables.categorical = c("pneuvac3")
for(variable in variables.categorical) {
  formula = as.formula(paste0("~", variable))
  table.frequency = svytotal(formula, brfss.design, na.rm = "TRUE")
  table.frequency
}

