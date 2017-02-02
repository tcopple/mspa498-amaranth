##This is an example eda file using the rda design files. In this script we'll load the 2011
##data and then output the frequency tables for two variables medcost and physhlth

library(survey)
library(MonetDBLite)
library(DBI)
library(stringr)

year = 2011
rdaFileName = paste0("./design-rdas/b", year, "design.rda")
load(rdaFileName)

variables.categorical = c("medcost", "physhlth")
for(variable in variables.categorical) {
  formula = as.formula(paste0("~", variable))
  table.frequency = svytotal(formula, brfss.d, na.rm = "TRUE")
  table.frequency
}