import os
import hashlib
import json
mdData={}
gPath=""

def formatPath(path):
    path=path.replace(gPath,"")
    path=path.replace("\\","/")
    return path;

def walk(path):
    fl = os.listdir(path) # get what we have in the dir.
    for f in fl:
        if os.path.isdir(os.path.join(path,f)): # if is a dir.
            walk(os.path.join(path,f))
        else: # if is a file
            fp = open(os.path.join(path,f),"rb") #open file. There is a big problem here. That is when you get a large file.
            c = fp.read() # get file content.
            m = hashlib.md5() # create a md5 object
            m.update(c) #encrypt the file
            tPath=formatPath(os.path.join(path,f))
            mdData[tPath]=str(m.hexdigest())
            fp.close() #close file
if __name__ == "__main__":
    mdData={}
    gPath=os.getcwd()+"\\"
    walk(os.getcwd())
    f=open("fileconfig.json","w")
    f.write(json.dumps(mdData))
    f.close();
    print(mdData)
