import sys
import os
import json

if __name__ == '__main__':

    if(len(sys.argv) < 2):
        print("Error: No file provided. " + sys.argv[0] + " json-datadict-file") #"format-file.txt sasout-file.txt")
        sys.exit(1)

    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)

    json_relpath = sys.argv[1]
    json_filepath = os.path.join(script_dir, json_relpath)
    csv_filepath = os.path.splitext(json_filepath)[0] + ".csv"

    data = {}
    with open(json_filepath) as json_handle:
        data = json.load(json_handle)

    print("Writing [" + csv_filepath + "]")
    with open(csv_filepath, 'w') as csv_handle:
        headers = ["Field Name", "Offset", "Size", "Type", "Levels", "Survey SubSection", "Description", "Derived Field"]
        csv_handle.write(', '.join(headers) + "\n")
        for variable, inner in data.items():
            label = inner["label"] if "label" in inner else ""
            location = inner["location"] if "location" in inner else ""
            section = inner["section"] if "section" in inner else ""
            derived = inner["derived"] if "derived" in inner else ""
            size = inner["size"] if "size" in inner else ""
            vtype = inner["type"] if "type" in inner else ""
            levels = inner["levels"] if "levels" in inner else ""

            rec = [str(variable), str(location), str(size), str(vtype), str(levels), str(section), str(label), str(derived)]
            rec = map(lambda itm: "\"" + itm + "\"", rec)
            csv_handle.write(','.join(rec) + "\n")
