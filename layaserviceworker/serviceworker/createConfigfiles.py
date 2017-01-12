import os
import hashlib
import json
mdData={}
configO={}
gPath=""
workPath="E:/wangwei/serviceworker/testserviceworker/trunk/layaserviceworker/bin/h5"
cacheSign="LayaAirGameCache";
workerPath="service-worker.js";

def formatPath(path):
    path=path.replace(gPath,"")
    path=path.replace("\\","/")
    return path;

def getFileMd5(path):
    fp = open(path,"rb") #open file. There is a big problem here. That is when you get a large file.
    c = fp.read() # get file content.
    m = hashlib.md5() # create a md5 object
    m.update(c) #encrypt the file
    fp.close() #close file
    return str(m.hexdigest())

def walk(path):
    fl = os.listdir(path) # get what we have in the dir.
    for f in fl:
        if os.path.isdir(os.path.join(path,f)): # if is a dir.
            walk(os.path.join(path,f))
        else: # if is a file
            tPath=formatPath(os.path.join(path,f))
            mdData[tPath]=getFileMd5(os.path.join(path,f))
            

def initConfig(filePath):
    global workPath,cacheSign,workerPath
    f=open(filePath,"r");
    jsontxt=f.read();
    f.close()
    jsono=json.loads(jsontxt)
    print(jsono)
    workPath=jsono["workDir"]
    if "cacheSign" in jsono:
        cacheSign=jsono["cacheSign"]
    if "workerPath" in jsono:
        workerPath=jsono["workerPath"]
def getWorkPath(relativePath):
    return os.path.join(workPath,relativePath);

def createFileVerFile():
    f=open(getWorkPath("fileconfig.json"),"w")
    f.write(json.dumps(mdData))
    f.close();
    
def createConfigFile():
    configData={};
    configData["cacheSign"]=cacheSign;
    configData["workerPath"]=workerPath;
    configData["fileVer"]=getFileMd5(getWorkPath("fileconfig.json"));
    f=open(getWorkPath("workerconfig.json"),"w")
    f.write(json.dumps(configData))
    f.close();
    
def beginWork():
    global gPath,mdData
    initConfig("serviceworkerconfig.json");
    mdData={}
    rPath=os.getcwd();
    gPath=workPath+"\\"
    print("workPath",workPath);
    walk(workPath)
    createFileVerFile();
    createConfigFile();
    print(mdData)

    
if __name__ == "__main__":
    beginWork();
