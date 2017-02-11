#the goal of this script is to output bar charts that correspond
#to the categorical variable distributions in the given survey design
#across two years

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

#filepaths for rda files
rda.2014 = paste0("./design-rda/b", year.2014, "design.rda")
rda.2015 = paste0("./design-rda/b", year.2015, "design.rda")

#load rda files that are backed by MonetDB
load(rda.2014)
load(rda.2015)

#load db connection
path.monet = paste0(getwd() , "/MonetDB")
monet.db = dbConnect(MonetDBLite::MonetDBLite(), path.monet)

#open db backed survey design
brfss.2014 = open(brfss.2014.design, driver=MonetDB.R())
brfss.2015 = open(brfss.2015.design, driver=MonetDB.R())

#navigate to data directory to find a data dictionary that will be used to map
#responses to their readable representations
codebook_filepath = paste0("../../data/supplemental/", year.2015, "datadict.json")
codebooks = fromJSON(codebook_filepath)

#location output files will be written
png.path = file.path("distributions-categorical")
dir.create(png.path)

#get all categorical variable names from helper function
variables.categorical = func.getCategoricalVars()

#eliminate variables that cause some issues in processing
predictors.categorical = setdiff(variables.categorical, c("ladult", "_state"))
for(variable in sort(predictors.categorical)) {
  print(paste0("Processing [", variable, "]"))
  formula = as.formula(paste0("~", variable))

  #calc frequency table for each year
  frequency.2014 = svytable(formula, brfss.2014)
  frequency.2015 = svytable(formula, brfss.2015)

  #turn table from counts into percentages, round them, and cast to a dataframe
  frame.2014 = as.data.frame(round(prop.table(frequency.2014), digits=3))
  frame.2014$year = 2014

  frame.2015 = as.data.frame(round(prop.table(frequency.2015), digits=3))
  frame.2015$year = 2015

  #join 2014 and 2015 data
  frame = rbind(frame.2014, frame.2015)
  colnames(frame) = c("response", "value", "year")

  #get field mappings from datadictionary
  responses = codebooks[variable]
  codes = stack(responses[[1]]$codes)
  colnames(codes) = c("value", "mnemonic")

  #create final dataframe with year, readable response name, and % surveyed
  freq = merge(frame, codes, by.x="response", by.y="mnemonic")
  freq$response = NULL
  colnames(freq) = c("value", "year", "response")

  #create bar plot
  plot = ggplot(data=freq, aes(x=response, y=value, fill=factor(year))) +
           geom_bar(stat="identity", position=position_dodge()) +
           labs(x="Response", y="Percent") + guides(fill=guide_legend(title=variable)) +
           theme(axis.text.x = element_text(angle = 25, hjust = 1))

  #save
  filepath = file.path(png.path, paste(variable, "distribution.png", sep="-"))
  ggsave(filepath, plot)
}
