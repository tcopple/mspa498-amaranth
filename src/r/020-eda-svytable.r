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

rda.path = file.path("demographic-by-response-tables")
dir.create(rda.path)

employ.by.flu.2014 = func.two.level.table(brfss.2014, "employ1", "flushot6", ~factor(employ1) + factor(flushot6), as.percent = TRUE)
save(employ.by.flu.2014, file = file.path(rda.path, "employ-by-flu-2014.rda"))

employ.by.flu.2015 = func.two.level.table(brfss.2015, "employ1", "flushot6", ~factor(employ1) + factor(flushot6), as.percent = TRUE)
save(employ.by.flu.2015, file = file.path(rda.path, "employ-by-flu-2015.rda"))

educa.by.flu.2014 = func.two.level.table(brfss.2014, "educa", "flushot6", ~factor(educa) + factor(flushot6), as.percent = TRUE)
save(educa.by.flu.2014, file = file.path(rda.path, "educa-by-flu-2014.rda"))

educa.by.flu.2015 = func.two.level.table(brfss.2015, "educa", "flushot6", ~factor(educa) + factor(flushot6), as.percent = TRUE)
save(educa.by.flu.2015, file = file.path(rda.path, "educa-by-flu-2015.rda"))

income2.by.flu.2014 = func.two.level.table(brfss.2014, "income2", "flushot6", ~factor(income2) + factor(flushot6), as.percent = TRUE)
save(income2.by.flu.2014, file = file.path(rda.path, "income2-by-flu-2014.rda"))

income2.by.flu.2015 = func.two.level.table(brfss.2015, "income2", "flushot6", ~factor(income2) + factor(flushot6), as.percent = TRUE)
save(income2.by.flu.2015, file = file.path(rda.path, "income2-by-flu-2015.rda"))

marital.by.flu.2014 = func.two.level.table(brfss.2014, "marital", "flushot6", ~factor(marital) + factor(flushot6), as.percent = TRUE)
save(marital.by.flu.2014, file = file.path(rda.path, "marital-by-flu-2014.rda"))

marital.by.flu.2015 = func.two.level.table(brfss.2015, "marital", "flushot6", ~factor(marital) + factor(flushot6), as.percent = TRUE)
save(marital.by.flu.2015, file = file.path(rda.path, "marital-by-flu-2015.rda"))

renthom1.by.flu.2014 = func.two.level.table(brfss.2014, "renthom1", "flushot6", ~factor(renthom1) + factor(flushot6), as.percent = TRUE)
save(renthom1.by.flu.2014, file = file.path(rda.path, "renthom1-by-flu-2014.rda"))

renthom1.by.flu.2015 = func.two.level.table(brfss.2015, "renthom1", "flushot6", ~factor(renthom1) + factor(flushot6), as.percent = TRUE)
save(renthom1.by.flu.2015, file = file.path(rda.path, "renthom1-by-flu-2015.rda"))

sex.by.flu.2014 = func.two.level.table(brfss.2014, "sex", "flushot6", ~factor(sex) + factor(flushot6), as.percent = TRUE)
save(sex.by.flu.2014, file = file.path(rda.path, "sex-by-flu-2014.rda"))

sex.by.flu.2015 = func.two.level.table(brfss.2015, "sex", "flushot6", ~factor(sex) + factor(flushot6), as.percent = TRUE)
save(sex.by.flu.2015, file = file.path(rda.path, "sex-by-flu-2015.rda"))

internet.by.flu.2014 = func.two.level.table(brfss.2014, "internet", "flushot6", ~factor(internet) + factor(flushot6), as.percent = TRUE)
save(internet.by.flu.2014, file = file.path(rda.path, "internet-by-flu-2014.rda"))

internet.by.flu.2015 = func.two.level.table(brfss.2015, "internet", "flushot6", ~factor(internet) + factor(flushot6), as.percent = TRUE)
save(internet.by.flu.2015, file = file.path(rda.path, "internet-by-flu-2015.rda"))
