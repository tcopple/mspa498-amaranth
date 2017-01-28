###THIS FILE USES THE MONETDB (think SQLite) TO
###GET A LIST OF ALL THE FIELDS WITHIN SEVERAL YEARS WORTH OF DATA
###IT THEN WRITES A CSV WITH THE FIELDS NAMES A ROWS AND THE YEARS
###THE FIELD IS IN AS COLUMN VALUES

library(survey)
library(MonetDBLite)
library(DBI)
library(stringr)
library(reshape2)

# name the database files in the "MonetDB" folder of the current working directory
dbfolder = paste0(getwd(), "/MonetDB")

# open the connection to the monetdblite database
db = dbConnect(MonetDBLite::MonetDBLite(), dbfolder)

# years to fetch fields for
years = c(2011:2015)

df.fields = data.frame(year = c(), fields = c(), found = c())
for(year in years){
  tableName = paste0("b", year)

  column.fields = dbListFields(db, tableName)
  column.year = rep(year, length(column.fields))
  column.found = rep(1, length(column.fields))

  df.fields = rbind(df.fields, data.frame(year = column.year, fields = column.fields, found = column.found))
}

fields.by.year = dcast(df.fields, fields ~ year, value.var = "found", fill = 0)
fields.by.year$count = fields.by.year$`2011` + fields.by.year$`2012` + fields.by.year$`2013` + fields.by.year$`2014` + fields.by.year$`2015`
fields.by.year = fields.by.year[order(-fields.by.year$count),]
rownames(fields.by.year) = NULL
write.csv(fields.by.year, "brfss-fields-by-year.csv")
