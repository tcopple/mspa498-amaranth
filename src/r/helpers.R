library(dplyr)

func.getAllVars = function() {
  return(c(func.getCategoricalVars(), func.getNumericVars()))
}

func.getCategoricalVars = function() {
  return(filter(read.csv("variable-details.csv", header = TRUE, sep = ","), Type == "categorical")$Field.Name)
}

func.getNumericVars = function() {
  return(filter(read.csv("variable-details.csv", header = TRUE, sep = ","), Type == "numeric" | Type == "integer")$Field.Name)
}

func.getResponseVars = function() {
  return(filter(read.csv("variable-details.csv", header = TRUE, sep = ","), Outcome == 1)$Field.Name)
}

func.getDemographicVars = function() {
  return(filter(read.csv("variable-details.csv", header = TRUE, sep = ","), Demographic == 1)$Field.Name)
}

func.getGeographicVars = function() {
  return(filter(read.csv("variable-details.csv", header = TRUE, sep = ","), Geographical == 1)$Field.Name)
}

func.two.level.table = function(study, var.x, var.y, formula, as.percent = FALSE){
  results = data.frame()
  if(as.percent) {
    results = as.data.frame(svytable(formula, study, Ntotal=100))
  } else {
    results = as.data.frame(svytable(formula, study))
  }

  colnames(results) = c(var.x, var.y, "freq")
  results = func.replace.codes(results, var.x)
  results = func.replace.codes(results, var.y)
  return(results[order(-results$freq),])
}

func.replace.codes = function(df, var.name) {
  codebook_filepath = paste0("../../data/supplemental/", year.2015, "datadict.json")
  codebooks = fromJSON(codebook_filepath)

  responses = codebooks[var.name]
  codes = stack(responses[[1]]$codes)
  colnames(codes) = c("value", "mnemonic")

  result = merge(df, codes, by.x=var.name, by.y="mnemonic")
  result[, var.name] = result$value
  result$value = NULL
  return(result)
}
