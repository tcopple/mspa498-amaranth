library(survey)
library(MonetDBLite)
library(DBI)
library(stringr)
library(jsonlite)
library(hash)
library(ggplot2)
library(parallel)
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

variable.state = as.formula("~xstate")
variable.flshot = as.formula("~flushot6")

options(survey.lonely.psu="adjust")
table.2014 = svytable(~factor(xstate)+factor(flushot6), brfss.2014)
table.2015 = svytable(~factor(xstate)+factor(flushot6), brfss.2015)