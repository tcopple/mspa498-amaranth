import sys
import os
import glob
import pandas

def convert_to_csv(xpt_filepath, csv_filepath):
    print("Converting ", xpt_filepath, " to ", csv_filepath)
    path = os.path.dirname(csv_filepath)
    if not os.path.exists(path):
        os.makedirs(path)

    df = pandas.read_sas(xpt_filepath, "XPORT")
    df.to_csv(csv_filepath, encoding='utf-8')

    return

if __name__ == '__main__':
    #local that store assumed paths

    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)
    xpts_path = os.path.join(script_dir, "020-xpts")
    csvs_path = os.path.join(script_dir, "030-csvs")

    #read all files in zips directory
    globs = os.path.join(xpts_path, "*")
    files = glob.glob(globs)

    print("Looking for files that match pattern [" + globs + "].")

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
