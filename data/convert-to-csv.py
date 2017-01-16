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

        file_name = os.path.basename(filepath)
        file_without_extension = os.path.splitext(file_name)[0]
        csv_filepath = os.path.join(csvs_path, file_without_extension + ".csv")

        convert_to_csv(filepath, csv_filepath)
