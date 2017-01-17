import sys
import os
import glob
import pandas

def convert_to_csv(xpt_filepath, csv_filepath):
    try:
        print("Converting ", xpt_filepath, " to ", csv_filepath)
        path = os.path.dirname(csv_filepath)
        if not os.path.exists(path):
            os.makedirs(path)

        df = pandas.read_sas(xpt_filepath)
        df.to_csv(csv_filepath, encoding='utf-8')

    except:
        msg = "Error: Failed converting " + xpt_filepath + "\n"
        sys.stderr.write(msg)
        sys.stderr.write(str(sys.exc_info()[0]))
        sys.exit(1)

    return

if __name__ == '__main__':
    #local that store assumed paths
    xpts_path = "./brfss-xpts/"
    csvs_path = "./brfss-csvs/"

    #read all files in zips directory
    files = glob.glob(xpts_path + "*")

    #one by one unzip the zip files to the xpt directory
    for filepath in files:

        #remote the path from the filepath
        file_name = os.path.basename(filepath).lower()

        #remote the extension from the filename and then take the last two characters
        #which in this case correspond to the year suffix, 00, 01, 02, etc.
        year_suffix = int(os.path.splitext(file_name)[0][-2:])

        year = -1
        if year_suffix > 50:
            year = 1900 + year_suffix
        else:
            year = 2000 + year_suffix

        filename = "brfss" + str(year) + ".csv"
        csv_filepath = os.path.join(csvs_path, filename)

        convert_to_csv(filepath, csv_filepath)
