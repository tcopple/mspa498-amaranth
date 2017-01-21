import sys
import os
import re
import json

if __name__ == '__main__':

    if(len(sys.argv) < 2):
        print("No format file given to process. Please pass the file name in as a command line parameter.")
        sys.exit(1)

    #first arg (index 0) is program name
    #second arg (index 1) is first commandline argument
    filepath = sys.argv[1]
    json_filepath = os.path.splitext(filepath)[0] + '.json'

    if(not os.path.exists(filepath)):
        print("Could not find [", filepath, "] please ensure it exists.")
        sys.exit(1)

    print("Converting [", filepath, "] to JSON @ [", json_filepath, "]")

    data = ""
    #do not remote the 'error's paramter, SAS files have windows style 'backticks'
    #which is not UTF8 compatible, when reading the file on a *nix environment
    #they're ignored
    with open(filepath, 'r', errors='ignore') as format_file:
        data = format_file.read()

    block_regex = re.compile('VALUE (.*?);', re.I | re.S)
    matches = block_regex.findall(data)

    mappings = {}
    for match in matches:
        lines_regex = re.compile('.*\n')
        lines = lines_regex.findall(match)
        field_name  = lines[0].strip().lower()
        if(not field_name in mappings):
            mappings[field_name] = {}

        for line in lines[1:]:
            fields = line.strip().split("=")
            numeric_value = fields[0].strip()
            categorical_value = fields[1].strip()

            #if the category is a numeric range remove spaces between text
            numeric_value = re.sub('\s+', ' ', numeric_value).strip()

            #remove quotes that would eventually be escaped
            if numeric_value.startswith('"') and numeric_value.endswith('"'):
                numeric_value = numeric_value[1:-1]

            if categorical_value.startswith('"') and categorical_value.endswith('"'):
                categorical_value = categorical_value[1:-1]

            mappings[field_name][numeric_value] = categorical_value

    with open(json_filepath, 'w') as json_handle:
        json.dump(mappings, json_handle, sort_keys=True, indent=4, separators=(',', ': '))
