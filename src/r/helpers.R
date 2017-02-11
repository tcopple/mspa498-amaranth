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