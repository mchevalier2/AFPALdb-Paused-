import sys,subprocess,os,warnings,json,numpy,time
import MySQLdb
import openpyxl

## Filtering a warning raised by openpyxl while opening the input data file
warnings.filterwarnings("ignore", category=UserWarning, module='openpyxl')

## Connection to the database to update
DB=MySQLdb.connect(db="AFPALdb",user="Manuu",passwd="cgkrggjn",host="localhost")
DB_CURSOR=DB.cursor()

## List of datasets to be added
if len(sys.argv) == 1:
    print "\033[91m \033[1m Here is an idea, a crazy idea. Run the script with data!\033[0m"
    exit(1)
else:
    list_files=sys.argv[1:]


## Neat little functions    
# Make sure to insert 'NULL' values when fields are empty
def Insert_NULL(s):
    ss=str(s)
    if ss=="None":
        return "NULL"
    if ss=="TRUE" or ss=="FALSE":
        return ss
    try:
        s+1
        return ss
    except:
        return "'%s'"%ss

    
# Return the highest Dataset_ID from the Dataset table    
def getIdDataset():
    nrow=DB_CURSOR.execute("Select Dataset_Id from Dataset order by Dataset_Id")
    if nrow>0:
        return int(DB_CURSOR.fetchall()[-1][0])+1
    else:
        return 0

    
# Return the highest Chrono_ID from the Chronology table    
def getIdChronology():
    nrow=DB_CURSOR.execute("Select Chrono_Id from Chronology order by Chrono_Id")
    if nrow>0:
        return int(DB_CURSOR.fetchall()[-1][0])+1
    else:
        return 0


# Return the dimensions of the terminal window 
def getTerminalSize():
    import os
    env = os.environ
    def ioctl_GWINSZ(fd):
        try:
            import fcntl, termios, struct, os
            cr = struct.unpack('hh', fcntl.ioctl(fd, termios.TIOCGWINSZ,
        '1234'))
        except:
            return
        return cr
    cr = ioctl_GWINSZ(0) or ioctl_GWINSZ(1) or ioctl_GWINSZ(2)
    if not cr:
        try:
            fd = os.open(os.ctermid(), os.O_RDONLY)
            cr = ioctl_GWINSZ(fd)
            os.close(fd)
        except:
            pass
    if not cr:
        cr = (env.get('LINES', 25), env.get('COLUMNS', 80))
    return int(cr[1]), int(cr[0])

    
## To color the text in the terminal 
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    
## C'est parti mon kiki  
for f in list_files:  
    print ""
    print ""
    print "c"*(getTerminalSize()[0])
    print "c %s"%f

    wb=openpyxl.load_workbook(f,keep_vba=True)

    # ----------------------------------------------------------------------------
    # Make Reference, Site, SiteRegion, RefSite
    try:
        sheet=wb['Metadata']
    except:
        print "c "+bcolors.FAIL+"No metadata sheet. Importation cancelled."+bcolors.ENDC
        print "c"*(getTerminalSize()[0])
        continue
            
    debut=0
    while sheet.rows[debut][0].value != "## Data":
        debut+=1
    debut+=1    
    
    CITATION_KEY=Insert_NULL(sheet.rows[debut+10][1].value)
    SITE_NAME=Insert_NULL(sheet.rows[debut][1].value)
 
    siteSQL="INSERT INTO Site (Site_Name, Group_Name, lon, lat, Archive, Country, Altitude, Terrestrial) VALUES ("+SITE_NAME+","+Insert_NULL(sheet.rows[debut+1][1].value)+","+Insert_NULL(sheet.rows[debut+2][1].value)+","+Insert_NULL(sheet.rows[debut+3][1].value)+","+Insert_NULL(sheet.rows[debut+4][1].value)+","+Insert_NULL(sheet.rows[debut+6][1].value)+","+Insert_NULL(sheet.rows[debut+7][1].value)+","+Insert_NULL(sheet.rows[debut+8][1].value)+");"

    referenceSQL="INSERT INTO Reference (Citation_Key, Authors, Published, Journal, Year, Volume, Issue, Pages, Title, DOI) VALUES ("+CITATION_KEY+","+Insert_NULL(sheet.rows[debut+11][1].value)+","+Insert_NULL(sheet.rows[debut+12][1].value)+","+Insert_NULL(sheet.rows[debut+13][1].value)+","+Insert_NULL(sheet.rows[debut+14][1].value)+","+Insert_NULL(sheet.rows[debut+15][1].value)+","+Insert_NULL(sheet.rows[debut+16][1].value)+","+Insert_NULL(sheet.rows[debut+17][1].value)+","+Insert_NULL(sheet.rows[debut+18][1].value)+","+Insert_NULL(sheet.rows[debut+19][1].value)+");"

    SITEREGION=False
    SiteRegionSQL="INSERT INTO SiteRegion (Site_Name, Region) VALUES "
    REGIONS=[y for y in [x.value for x in sheet.rows[debut+5][1:]] if y != None]
    for region in REGIONS:
        SITEREGION=True
        SiteRegionSQL+="("+SITE_NAME+","+Insert_NULL(region)+"),"
    SiteRegionSQL=SiteRegionSQL[:-1]+";"

    REFSITE=True
    RefSiteSQL="INSERT INTO RefSite (Citation_Key, Site_Name) VALUES (%s,%s),"%(CITATION_KEY,SITE_NAME)
    if sheet.rows[debut+9][1].value:
        REGIONS=[y for y in [x.value for x in sheet.rows[debut+9][2:]] if y != None]
        for region in REGIONS:
            RefSiteSQL+="(%s,%s),"%(CITATION_KEY,Insert_NULL(region))
    RefSiteSQL=RefSiteSQL[:-1]+";"

    # ----------------------------------------------------------------------------
    # Make C14
    C14=True
    try:
        sheet=wb['C14']
        debut=0
        while sheet.rows[debut][0].value != "## Data":
            debut+=1
        debut+=2   
        if debut < len(sheet.rows)-1:
            C14SQL="INSERT INTO C14 (LabCode, Site_Name, Citation_Key, Age, Error, Depth, Year, Material) VALUES "
            for i in range(debut,len(sheet.rows)):
                C14SQL+="("+Insert_NULL(sheet.rows[i][0].value)+","+SITE_NAME+","+CITATION_KEY+","+Insert_NULL(sheet.rows[i][1].value)+","+Insert_NULL(sheet.rows[i][2].value)+","+Insert_NULL(sheet.rows[i][3].value)+","+Insert_NULL(sheet.rows[i][4].value)+","+Insert_NULL(sheet.rows[i][5].value)+"),"
            C14SQL=C14SQL[:-1]+";"
        else:
            C14=False
    except:
        C14=False


    # ----------------------------------------------------------------------------
    # Make Dataset and Chronology
    datasheets=[y for y,e in enumerate([x.find("Data") for x in wb.get_sheet_names()]) if e==0]
    chronosheets=[y for y,e in enumerate([x.find("Chrono") for x in wb.get_sheet_names()]) if e==0]
    DataSQL=[]
    ChronoSQL=[]
    ChronoC14SQL=[]
    
    DATASET_ID=getIdDataset()
    dataset_id={}
    CHRONOLOGY_ID=getIdChronology()
    chronology_id={}

    DATASET=True
    CHRONOLOGY=True
    CHRONOC14=True
    
    if len(datasheets) == 0:
        DATASET=False
    if len(chronosheets) == 0:
        CHRONOLOGY=False
        CHRONOC14=False
        
    for i in range(len(datasheets)):
        PROXY_NAME=wb.get_sheet_names()[datasheets[i]][5:]
        dataset_id[DATASET_ID]=[]
        sheet=wb[wb.get_sheet_names()[datasheets[i]]]
        debut=0
        while sheet.rows[debut][0].value != "## Data":
            debut+=1
        debut+=4
        if debut < len(sheet.rows)-1:
            DataSQL.append("INSERT INTO Dataset (Dataset_ID, Site_Name, Citation_Key, Proxy, Digitized, Dataset, Uncertainties) VALUES ")
            NCOLS=sum([y != None for y in [x.value for x in sheet.rows[debut][1:]]])+1
            NCHRONO=[str(y) for y in [x.value for x in sheet.rows[debut-3][1:]] if y != None ]
            if sheet.rows[debut-2][1].value=='Independent Entries':
                for j in range(1,NCOLS):
                    PROXY=[x[j].value for x in sheet.rows[debut:]]
                    data={}
                    data[PROXY[0]]=PROXY[1:]
                    json_data=json.dumps(data)
                    DataSQL[-1]+="("+str(DATASET_ID)+","+SITE_NAME+','+CITATION_KEY+","+Insert_NULL(PROXY[0])+','+Insert_NULL(sheet.rows[debut-1][1].value)+",'"+json_data+"',NULL),"
                    dataset_id[DATASET_ID]=NCHRONO
                    DATASET_ID+=1
                DataSQL[-1]=DataSQL[-1][:-1]+";"
            elif sheet.rows[debut-2][1].value=='Matrix of data':
                data={}
                for j in range(1,NCOLS):
                    PROXY=[x[j].value for x in sheet.rows[debut:]]
                    data[PROXY[0]]=PROXY[1:]
                json_data=json.dumps(data)
                DataSQL[-1]+="("+str(DATASET_ID)+','+SITE_NAME+','+CITATION_KEY+","+Insert_NULL(PROXY_NAME)+','+Insert_NULL(sheet.rows[debut-1][1].value)+",'"+json_data+"',NULL);"
                dataset_id[DATASET_ID]=NCHRONO
                DATASET_ID+=1
            else:
                data={}
                uncertainties={}
                for j in range(2,NCOLS):
                    PROXY=[x[j].value for x in sheet.rows[debut:]]
                    uncertainties[PROXY[0]]=PROXY[1:]
                json_uncertainties=json.dumps(uncertainties)
                PROXY=[x[1].value for x in sheet.rows[debut:]]
                data[PROXY[0]]=PROXY[1:]
                json_data=json.dumps(data)
                DataSQL[-1]+="("+str(DATASET_ID)+','+SITE_NAME+','+CITATION_KEY+","+Insert_NULL(PROXY_NAME)+','+Insert_NULL(sheet.rows[debut-1][1].value)+",'"+json_data+"','"+json_uncertainties+"');"
                dataset_id[DATASET_ID]=NCHRONO
                DATASET_ID+=1
        else:
            DATASET=False
            
    for i in range(len(chronosheets)):
        CHRONO_NAME=wb.get_sheet_names()[chronosheets[i]][7:]
        chronology_id[CHRONO_NAME]=CHRONOLOGY_ID
        sheet=wb[wb.get_sheet_names()[chronosheets[i]]]
        debut=0
        while sheet.rows[debut][0].value != "## Data":
            debut+=1
        debut+=4
        if debut < len(sheet.rows)-1:
            ChronoSQL.append("INSERT INTO Chronology (Chrono_ID, Citation_Key, Site_Name, Chrono_Name, Model, Digitized, Sample, Depth, Chronology, Uncertainties) VALUES ")
            ChronoC14SQL.append("INSERT INTO ChronoC14 (Chrono_ID, LabCode) VALUES ")
            NCOLS=sum([y != None for y in [x.value for x in sheet.rows[debut-3][1:]]])+1
            for j in range(1,NCOLS):
                ChronoC14SQL[-1]+="("+str(CHRONOLOGY_ID)+","+Insert_NULL(sheet.rows[debut-3][j].value)+"),"
            ChronoC14SQL[-1]=ChronoC14SQL[-1][:-1]+";"
            SAMPLE=[x[0].value for x in sheet.rows[debut:]]
            data={}
            data[SAMPLE[0]]=SAMPLE[1:]
            json_data_sample=json.dumps(data)
            DEPTH=[x[1].value for x in sheet.rows[debut:]]
            data={}
            data[DEPTH[0]]=DEPTH[1:]
            json_data_depth=json.dumps(data)  
            CHRONO=[x[2].value for x in sheet.rows[debut:]]
            data={}
            data[CHRONO[0]]=CHRONO[1:]
            json_data_chrono=json.dumps(data)
            data={}
            for j in range(3,len(sheet.rows[debut])):
                ERRORS=[x[j].value for x in sheet.rows[debut:]]
                data[ERRORS[0]]=ERRORS[1:]
            json_data_uncertainties=json.dumps(data)
            ChronoSQL[-1]+="("+str(CHRONOLOGY_ID)+','+CITATION_KEY+","+SITE_NAME+",'"+CHRONO_NAME+"',"+Insert_NULL(sheet.rows[debut-2][1].value)+","+Insert_NULL(sheet.rows[debut-1][1].value)+",'"+json_data_sample+"','"+json_data_depth+"','"+json_data_chrono+"','"+json_data_uncertainties+"');"
            CHRONOLOGY_ID+=1
        else:
            CHRONOLOGY=False
            CHRONOC14=False
    
    # ----------------------------------------------------------------------------
    # Make ChronoData

    CHRONODATA=True
    if CHRONOLOGY and DATASET:
        ChronoDataSQL="INSERT INTO ChronoData (Chrono_ID, Dataset_ID) VALUES "
        for i in dataset_id.keys()[::-1]:
            chrono_keys=chronology_id.keys()
            for j in dataset_id[i]:
                ChronoDataSQL+="("+str(chronology_id[j])+","+str(i)+"),"
        ChronoDataSQL=ChronoDataSQL[:-1]+";"
    else:
        CHRONODATA=False
    

    # ----------------------------------------------------------------------------
    # Sending data to the database

    DB_CURSOR.execute("START TRANSACTION;")
    CONTINUE=0
    try:
        DB_CURSOR.execute(referenceSQL)
        print "c\nc " + bcolors.OKGREEN + "Reference OK." + bcolors.ENDC
    except:
        print "c\nc "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key '%s' in 'Reference'."%CITATION_KEY + bcolors.ENDC
        xx=raw_input("c Should the new data be linked to the existing entry '%s'? [Y/N] "%CITATION_KEY )
        while not (xx == "Y" or xx== "y" or xx == "N" or xx == "n"):
            xx=raw_input("c Should the new data be linked to the existing entry '%s'? [Y/N] "%CITATION_KEY )
        print "c"
        if xx =="N" or xx == "n":
            print "c\nc " + bcolors.FAIL + bcolors.BOLD + "Script aborded. The database was not updated." + bcolors.ENDC
            CONTINUE=999
        CONTINUE+=1
        REFSITE=False
        
    if CONTINUE <2:
        try:
            DB_CURSOR.execute(siteSQL)
            print "c " + bcolors.OKGREEN + "Site OK." + bcolors.ENDC
        except:
            print "c\nc "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key '%s' in 'Site'. Importation cancelled. Check the data."%SITE_NAME + bcolors.ENDC
            xx=raw_input("c Should the new data be linked to the existing entry '%s'? [Y/N] "%SITE_NAME)
            while not (xx == "Y" or xx== "y" or xx == "N" or xx == "n"):
                xx=raw_input("c Should the new data be linked to the existing entry '%s'? [Y/N] "%SITE_NAME)
            print "c"
            if xx =="N" or xx == "n":
                print "c\nc " + bcolors.FAIL + bcolors.BOLD + "Script aborded. The database was not updated." + bcolors.ENDC
                CONTINUE=999
            CONTINUE+=1
            SITEREGION=False

    if CONTINUE<2:
        COMMIT=True
        if REFSITE:
            try:
                DB_CURSOR.execute(RefSiteSQL)
                print "c " + bcolors.OKGREEN + "RefSite OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'RefSite'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No new RefSite entry without a new Reference. (--> Update scripts)" + bcolors.ENDC
            
        if SITEREGION:
            try:
                DB_CURSOR.execute(SiteRegionSQL)
                print "c " + bcolors.OKGREEN + "SiteRegion OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'SiteRegion'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No new SiteRegion entry without a new Site. (--> Update scripts)" + bcolors.ENDC

        if C14:
            try:
                DB_CURSOR.execute(C14SQL)
                print "c " + bcolors.OKGREEN + "C14 OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'C14'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No C14 dates associated with the file." + bcolors.ENDC

        if DATASET:
            try:
                [DB_CURSOR.execute(x) for x in DataSQL]
                print "c " + bcolors.OKGREEN + "Dataset OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'Dataset'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No Dataset associated with the file." + bcolors.ENDC

        if CHRONOLOGY:
            try:
                [DB_CURSOR.execute(x) for x in ChronoSQL]
                print "c " + bcolors.OKGREEN + "Chronology OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'Chronology'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No Chronology associated with the file." + bcolors.ENDC

        if CHRONODATA:
            try:
                DB_CURSOR.execute(ChronoDataSQL)
                print "c " + bcolors.OKGREEN + "ChronoData OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'ChronoData'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No Chronology nor Dataset associated with the file." + bcolors.ENDC

        if CHRONOC14:
            try:
                [DB_CURSOR.execute(x) for x in ChronoC14SQL]
                print "c " + bcolors.OKGREEN + "ChronoC14 OK." + bcolors.ENDC
            except:
                print "c "+ bcolors.FAIL +"/!\ Alert. Duplicated Primary Key in 'ChronoC14'. Importation cancelled. Check the data." + bcolors.ENDC
                COMMIT=False     
        else:
            print  "c "+ bcolors.WARNING +"/!\ Warning. No Chronology associated with the file." + bcolors.ENDC
        if COMMIT:
            if CHRONOC14 and CHRONODATA and CHRONOLOGY and DATASET and C14 and SITEREGION and REFSITE:    
                DB_CURSOR.execute("COMMIT;")
                print "c\nc " + bcolors.OKGREEN + bcolors.BOLD + "Importation completed. No errors." + bcolors.ENDC
            else:
                xx=raw_input("c\nc Warnings were raised. Should the database be updated?" + bcolors.ENDC+" [Y/N] ")
                while not (xx == "Y" or xx== "y" or xx == "N" or xx == "n"):
                    xx=raw_input("c Warnings were raised. Should the database be updated?" + bcolors.ENDC+" [Y/N] ")
                if xx.upper() == "Y":
                    DB_CURSOR.execute("COMMIT;")
                    print "c\nc " + bcolors.OKGREEN + bcolors.BOLD + "Importation completed. No errors." + bcolors.ENDC
                else:
                    DB_CURSOR.execute("ROLLBACK;")
                    print "c\nc " + bcolors.FAIL + bcolors.BOLD + "Importation Stopped. The database was not updated." + bcolors.ENDC

        else:
            DB_CURSOR.execute("ROLLBACK;")
            print "c\nc " + bcolors.FAIL + bcolors.BOLD + "Importation failed. The database was not updated." + bcolors.ENDC

    elif CONTINUE==2:
        print "c\nc " + bcolors.FAIL + bcolors.BOLD + "Hey Ho Coco! Not a new Site nor a new Reference. Consider the 'update scripts' instead." + bcolors.ENDC+"\nc " + bcolors.FAIL + bcolors.BOLD + "The database was not updated." + bcolors.ENDC

    print "c"*(getTerminalSize()[0])


# Close database connection    
DB_CURSOR.close()
DB.close()


print "\n\n"
print "c"*(getTerminalSize()[0])
xx=raw_input("c "+ bcolors.OKGREEN + "Do you want to make a SQLite3 backup of the database?"+ bcolors.ENDC+" [Y/N] ")
while not (xx == "Y" or xx== "y" or xx == "N" or xx == "n"):
    xx=raw_input("c "+ bcolors.OKGREEN + "Do you want to make a SQLite3 backup of the database?"+ bcolors.ENDC+" [Y/N] ")
if xx =="Y" or xx == "y":
    DB_NAME="AFPALdb_%d.sqlite3"%(int(time.time()))
    xx=raw_input("c "+ bcolors.OKGREEN + "Folder to save %s (Leave empty to use default /Users/chevalier/Workspace/AFPALdb/Backup): "%DB_NAME+ bcolors.ENDC)
    if xx=="":
        xx="/Users/chevalier/Workspace/AFPALdb/Backup"
    if xx[-1]==" ":
        xx=xx[:-1]
    if xx[-1]!="/":
        xx=xx[:]+"/"
    xx=xx+DB_NAME
    print "c File saved as: %s"%xx
    os.system("/Users/chevalier/Workspace/AFPALdb/Backup/mysql2sqlite.sh -u Manuu -p AFPALdb | sqlite3 %s"%xx)
print "c"*(getTerminalSize()[0])

