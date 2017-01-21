# much of this is taken from
# https://github.com/ajdamico/asdfree/tree/master/Behavioral%20Risk%20Factor%20Surveillance%20System
# but it's been modified for usage in MSPA480

####################################################################################
# download all available behavioral risk factor surveillance system files from the #
# centers for disease control and prevention (cdc) website, then import each file  #
# into a monet database, and create a monet database-backed survey object with r   #
####################################################################################

# # # # # # # # # # # # # # # #
# warning: this takes a while #
# # # # # # # # # # # # # # # #

# even if you're only downloading a single year of data and you've got a fast internet connection,
# you'll be better off leaving this script to run overnight.  if you wanna download all available years,
# leave it running on friday afternoon (or even better: before you leave for a weeklong vacation).
# depending on your internet and processor speeds, the entire script should take between two and ten days.
# it's running.  don't believe me?  check the working directory (set below) for a new r data file (.rda) every few hours.

packages = rownames(installed.packages())
if(!"MonetDBLite" %in% packages) { install.packages("MonetDBLite") }
if(!"survey" %in% packages) { install.packages("survey") }
if(!"SAScii" %in% packages) { install.packages("SAScii") }
if(!"descr" %in% packages) { install.packages("descr") }
if(!"downloader" %in% packages) { install.packages("downloader") }
if(!"digest" %in% packages) { install.packages("digest") }

library(survey)			# load survey package (analyzes complex design surveys)
library(MonetDBLite)
library(DBI)			# load the DBI package (implements the R-database coding)
library(foreign) 		# load foreign package (converts data files into R)
library(downloader)		# downloads and then runs the source() function on scripts from github
library(R.utils)		# load the R.utils package (counts the number of lines in a file quickly)
source("downloader.r")

# set your BRFSS data directory
# after downloading and importing
# all monet database-backed complex survey designs will be stored here
# and the monet database will be stored in the MonetDB folder within
# use forward slashes instead of back slashes

# uncomment this line by removing the `#` at the front..
# setwd( "C:/My Directory/BRFSS/" )

# # # are you on a non-windows system? # # #
if ( .Platform$OS.type != 'windows' ) {
  print('NON-WINDOWS USERES: READ THIS BLOCK.' )

  # the cdc's ftp site has a few SAS importation
  # scripts in a non-standard format
  # if so, before running this whole download program,
  # you might need to run this line to turn on windows style EOL encoding
  options( encoding="windows-1252" )
}

# load the download_cached and related functions
# to prevent re-downloading of files once they've been downloaded.
source_url(
  "https://raw.githubusercontent.com/ajdamico/asdfree/master/Download%20Cache/download%20cache.R",
  prompt = FALSE,
  echo = FALSE
)

# load the read.SAScii.monetdb() function,
# which imports ASCII (fixed-width) data files directly into a monet database
# using only a SAS importation script
source_url(
  "https://raw.githubusercontent.com/ajdamico/asdfree/master/MonetDB/read.SAScii.monetdb.R",
  prompt = FALSE
)

# uncomment this line to only download the 2011 single-year file and no others
years.to.download <- c(2005:2015)

for(year in years.to.download) {
  func.download.year(year)
}