import glob
import zipfile
import os

def unzip_file(local_file, unzip_path):
    print("Unzipping ", local_file, " to ", unzip_path)
    zf = zipfile.ZipFile(local_file, 'r')
    zf.extractall(unzip_path)
    zf.close

##ENTRY POINT
if __name__ == '__main__':

    #get absolute path of currently running file
    script_path = os.path.realpath(__file__)
    script_dir = os.path.dirname(script_path)

    #local that store assumed paths
    zips_path = os.path.join(script_dir, "brfss-zips", "*")
    xpts_path = os.path.join(script_dir, "brfss-xpts", "*")

    print("Reading all zips from [" + zips_path + "].")

    #read all files in zips directory
    files = glob.glob(zips_path)

    #one by one unzip the zip files to the xpt directory
    for filename in files:
        unzip_file(filename, xpts_path)
