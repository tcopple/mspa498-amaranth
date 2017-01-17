import os
import urllib.request
import sys
import csv
import shutil

#locals
ftp_filename = "files.csv"
remote_header = "remote_path"
local_header = "local_path"

def download_file(url, local_file):
    print('Attempting to save', url, "to", local_file)

    try:
        #if directory of local path does not exist, create it
        path = os.path.dirname(local_path)
        if not os.path.exists(path):
            os.makedirs(path)

        #fetch remote file storying it piecewise to local file
        with urllib.request.urlopen(remote_path) as response, open(local_path, 'wb') as local:
            shutil.copyfileobj(response, local)

    except:
        msg = "Error: Failed opening " + url + "\n"
        sys.stderr.write(msg)
        sys.stderr.write(sys.exc_info()[0])
        sys.exit(1)

    return

##ENTRY POINT
if __name__ == '__main__':

    #open file with list of remote paths
    files = list()
    with open(ftp_filename) as csvfile:

        #read file as a dictionary where the csv header are keys
        reader = csv.DictReader(csvfile)

        #for each row in the csv file
        for row in reader:
            #lookup remote and local path
            remote_path = row[remote_header]
            local_path = row[local_header]

            download_file(remote_path, local_path)
