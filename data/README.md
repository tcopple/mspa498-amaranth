##Data Directory

###Summary
This directory is designed to store permanant and temporary data files related to the team project. It also has a number of scripts that can be used to fetch and transorm data prior to consumption. Feel free to add raw data or data processing code files to this location. However, modeling code should be added to ../src/.

###Getting Started
####Downloading the BRFSS Data
Several python files are provided to download the raw BRFSS data. Execute the following commands in the following order.

    ~ python 010-fetch.py
    ~ python 020-unzip.py
    ~ python 030-convert-to-csv.py
    ~ python 040-remove-vars.py

###Directories

  /files.csv - stores a list of files to download from the BRFSS website

  /codebooks - a directory with the codebooks from many of the downloaded years

  /supplemental - a directory of sas and text files, with python scripts that create json files that represent data dictionaries
