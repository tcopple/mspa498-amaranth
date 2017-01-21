##R Source Directory

###Summary
The following directory contains r source code files and temporary objects they create.

###Getting Started
To download the BRFSS data permanantly for analysis in R. Run the `update.r` script which will include
`downloader.r`. This will take sometime to run and download all the data from 2005 to 2015. If you wish to
change the date range edit the `years.to.download` variable in `update.r`.

###Files

 ./

 ./brfss-fetch.r - a wrapper file that downloads BRFSS data and loads it year by year into a MonetDB database, which is like a SQL database in a file on your disk

 ./downloader.r - used by brfss-fetch.r

 ./example-analysis.r - this can be used as an example analysis once all the data has been downloaded, by default it requires the 2011 data.
