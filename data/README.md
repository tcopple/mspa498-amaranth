##Data Directory

###Summary
This directory is designed to store permanant and temporary data files related to the team project. It also has a number of scripts that can be used to fetch and transorm data prior to consumption. Feel free to add raw data or data processing code files to this location. However, modeling code should be added to ../src/.

###Getting Started
####Downloading the BRFSS Data
Three python files are provided to download the raw BRFSS data. Execute the following commands in the following order.
The first file fetches the raw zips from the BRFSS website. The second script unzips the zip files to xpt files. The third
script converts the XPT SAS formatted files to csv.

    ~ python brfss-fetch.py
    ~ python brfss-unzip.py
    ~ python brfss-convert.py

###Files

  /files.csv - stores a list of files to download from the BRFSS website

  /brfss-fetch.py - script to download files listed in `./files.csv`, stores them to directory `/brfss-zips`

  /brfss-unzip.py - unzips every file in `/brfss-zips` to `/brfss-xpts`

  /brfss-convert.py - converts xpt files in `/brfss-xpts` to csv files located in `/brfss-csvs`

  /codebooks - a directory with the codebooks from many of the downloaded years

  /formats - a sas & json directory with variable code mappings for use in other languages
