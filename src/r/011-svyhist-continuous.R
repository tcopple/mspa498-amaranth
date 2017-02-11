library(survey)
library(MonetDBLite)
library(DBI)
library(stringr)
library(jsonlite)
library(hash)
library(ggplot2)
source("helpers.R")

year.2014 = 2014
year.2015 = 2015

rda.2014 = paste0("./design-rda/b", year.2014, "design.rda")
rda.2015 = paste0("./design-rda/b", year.2015, "design.rda")

load(rda.2014)
load(rda.2015)

path.monet = paste0(getwd() , "/MonetDB")
monet.db = dbConnect(MonetDBLite::MonetDBLite(), path.monet)

brfss.2014 = open(brfss.2014.design, driver=MonetDB.R())
brfss.2015 = open(brfss.2015.design, driver=MonetDB.R())

png.path = file.path("distributions-continuous")
dir.create(png.path)

variables.numeric = func.getNumericVars()

options(survey.lonely.psu="adjust")
predictors.numeric = setdiff(variables.numeric, c("iyear", "ladult", "stateres")) #remote two vars we don't care about dists for
predictors.numeric = c("weight2", "wtkg3")
for(variable in sort(predictors.numeric)) {
  print(paste0("Processing [", variable, "]"))
  formula = as.formula(paste0("~", variable))

  filepath = file.path(png.path, paste(variable, "2014", "distribution.png", sep="-"))
  jpeg(filepath)
  svyhist(formula, brfss.2014, breaks=30, main=paste("2014", variable, sep=" "), xlab="")
  dev.off()

  filepath = file.path(png.path, paste(variable, "2015", "distribution.png", sep="-"))
  jpeg(filepath)
  svyhist(formula, brfss.2015, breaks=30, main=paste("2015", variable, sep=" "), xlab="")
  dev.off()
}
