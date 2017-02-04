import sys
import os
import glob
import pandas

variable_list = ["_strat", "_psu", "_record", "_state", "_finalwt", "addepev2", "alcday5", "asthma3",
                 "asthnow", "avedrnk2", "blind", "cadult", "age", "height", "weight",
                 "cclghous", "chccopd1", "chckidny", "chcocncr", "chcscncr", "checkup1", "children",
                 "cpdemo1", "cvdcrhd4", "cvdinfr4", "cvdstrk3", "decide", "diabage2", "diabete3", "diffalon",
                 "diffdres", "diffwalk", "drnk3ge5", "drnkany5", "educa", "employ1", "exerany2", "flshtmy2",
                 "flushot6", "genhlth", "havarth3", "height3", "hivtst6", "hivtstd3", "hlthpln1", "htin4",
                 "htm4", "imfvplac", "imonth", "income2", "internet", "iyear", "ladult", "lastsmk2", "marital",
                 "maxdrnks", "medcost", "menthlth", "mscode", "numadult", "numhhol2", "nummen", "numphon2", "numwomen",
                 "persdoc2", "physhlth", "pneuvac3", "poorhlth", "pregnant", "pvtresd1", "pvtresd2", "qlactlm2",
                 "renthom1", "seatbelt", "sex", "smokday2", "smoke100", "stateres", "stopsmk2", "useequip",
                 "usenow3", "veteran3", "weight2", "whrtst10", "wtkg3"]

def drop_variables(csv_filepath, processed_filepath):
    print("Dropping variables from [", csv_filepath, "] and writing to [", processed_filepath, "]")

    path = os.path.dirname(processed_filepath)
    if not os.path.exists(path):
        os.makedirs(path)

    frame = pandas.read_csv(csv_filepath)
    for variable_name in list(frame):
        if(not variable_name.lower() in variable_list):
            frame.drop(variable_name, axis=1, inplace=True)

    frame.to_csv(processed_filepath, encoding='utf-8')
    return

if __name__ == '__main__':

    #local that store assumed paths
    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)
    csvs_path = os.path.join(script_dir, "030-csvs")
    processed_path = os.path.join(script_dir, "040-trimmed-vars")

    #read all files in zips directory
    globs = os.path.join(csvs_path, "*")
    files = glob.glob(globs)

    print("Looking for files that match pattern [" + globs + "].")
    for filepath in files:

        file_name = os.path.basename(filepath).lower()

        output_path = os.path.join(processed_path, file_name)
        drop_variables(filepath, output_path)

