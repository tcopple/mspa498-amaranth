import glob
import zipfile

def unzip_file(local_file, unzip_path):
    print("Unzipping ", local_file, " to ", unzip_path)
    zf = zipfile.ZipFile(local_file, 'r')
    zf.extractall(unzip_path)
    zf.close

##ENTRY POINT
if __name__ == '__main__':
    #local that store assumed paths
    zips_path = "./brfss-zips/*"
    xpts_path = "./brfss-xpts/"

    #read all files in zips directory
    files = glob.glob(zips_path)

    #one by one unzip the zip files to the xpt directory
    for filename in files:
        unzip_file(filename, xpts_path)

