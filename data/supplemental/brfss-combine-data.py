import sys
import os
import re
import json

def process_format_file(format_filepath):

    if(not os.path.exists(format_filepath)):
        print("Could not find [", format_filepath, "] please ensure it exists.")
        sys.exit(1)

    data = ""

    #do not remote the 'error's paramter, SAS files have windows style 'backticks'
    #which is not UTF8 compatible, when reading the file on a *nix environment
    #they're ignored
    with open(format_filepath, 'r', errors='ignore') as format_file:
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

    return mappings

def process_sasout_file(sasout_filepath):

    if(not os.path.exists(sasout_filepath)):
        print("Could not find [", sasout_filepath, "] please ensure it exists.")
        sys.exit(1)

    data = ""
    #do not remote the 'error's paramter, SAS files have windows style 'backticks'
    #which is not UTF8 compatible, when reading the file on a *nix environment
    #they're ignored
    with open(sasout_filepath, 'r', errors='ignore') as format_file:
        data = format_file.read()

    block_regex = re.compile('(?P<VARS>^INPUT$(.*?)^;$).*?(?P<LABELS>^LABEL$(.*?)^;$)', re.I | re.S | re.M)
    block = block_regex.search(data)

    variables = block.group("VARS")
    labels = block.group("LABELS")

    data = {}
    section = ""
    variables_regex = re.compile('(?P<VAR>.*?)\s+\$?(?P<LOC>\d+(?:-\d+)?)(?:\s+/\* (?:Section\s+\d+: )?(?P<COMMENT>.*?) \*/)*')
    for line in variables_regex.finditer(variables):

        variable = line.group("VAR").strip().lower()
        location = line.group("LOC").strip()
        comment = line.group("COMMENT")
        section = comment if comment else section

        data[variable] = {}

        locations = location.split("-")
        x = int(locations[0])
        y = int(locations[1]) if len(locations) == 2 else int(x)
        data[variable]["location"] = x
        data[variable]["size"] = y - x + 1
        data[variable]["section"] = section.lower()

    labels_regex = re.compile("(?P<VAR>.*?) = '(?P<LABEL>.*?)'")
    for line in labels_regex.finditer(labels):

        variable = line.group("VAR").lower()
        label = line.group("LABEL").lower()

        data[variable]["label"] = label

    return data

def process_mapper_file(mapper_filepath):

    if(not os.path.exists(mapper_filepath)):
        print("Could not find [", mapper_filepath, "] please ensure it exists.")
        sys.exit(1)

    data = ""
    #do not remote the 'error's paramter, SAS files have windows style 'backticks'
    #which is not UTF8 compatible, when reading the file on a *nix environment
    #they're ignored
    with open(mapper_filepath, 'r', errors='ignore') as handle:
        data = handle.read()

    mapper_regex = re.compile('FORMAT(?P<BODY>.*?);', re.I | re.S | re.M)
    block = mapper_regex.search(data)

    body = block.group("BODY")

    mappings = {}
    mapping_regex = re.compile('(?P<LHS>\w*?)\s+(?P<RHS>\$?\w*?)\.', re.I | re.S | re.M)
    for mapping in mapping_regex.finditer(body):

        lhs = mapping.group("LHS").strip().lower()
        rhs = mapping.group("RHS").strip().lower()

        mappings[lhs] = rhs

    return mappings

if __name__ == '__main__':

    if(len(sys.argv) < 2):
        print(sys.argv[0] + "year") #"format-file.txt sasout-file.txt")
        sys.exit(1)

    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)

    year = sys.argv[1]
    sasout_filepath = os.path.join(script_dir, year + "sasout.txt")
    format_filepath = os.path.join(script_dir, year + "format.txt")
    mapper_filepath = os.path.join(script_dir, year + "formas.txt")

    json_filepath = os.path.join(script_dir, year + 'datadict.json')

    format_dict = process_format_file(format_filepath)
    sasout_dict = process_sasout_file(sasout_filepath)
    mappings_dict = process_mapper_file(mapper_filepath)

    for key, value in sasout_dict.items():
        sasout_dict[key]["derived"] = 1
        if not key in mappings_dict:
            print("Cannot find key[" + key + "] in mappings label is [" + value["section"] +"].")
            sasout_dict[key]["type"] = "numeric"
            sasout_dict[key]["levels"] = 0
            continue;

        format_key = mappings_dict[key]

        categorical = 1
        levels = ""
        if format_key in format_dict:
            codes = format_dict[format_key]
            sasout_dict[key]["codes"] = codes
            sasout_dict[key]["derived"] = 0

            code_keys = codes.keys()
            for code_key in code_keys:
                if "-" in code_key:
                    categorical = 0

            if(categorical == 1):
                levels = len(codes.keys())

        sasout_dict[key]["type"] = "categorical" if categorical else "integer"
        sasout_dict[key]["levels"] = levels if categorical else ""

        sasout_dict[key]["alt-name"] = format_key

    print("Writing to JSON @ [", json_filepath, "]")

    mappings = sasout_dict
    with open(json_filepath, 'w') as json_handle:
        json.dump(mappings, json_handle, sort_keys=True, indent=4, separators=(',', ': '))
