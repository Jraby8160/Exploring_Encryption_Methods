
import glob
import os

def folder_reader(path="C:/Users/jraby/Documents/Python\\",name="*",file_format="txt"):
    return(glob.glob(path+name+"."+file_format))


def file_name(file_path):
    return file_path[:file_path.find('\\')+1],file_path[file_path.find('\\')+1:file_path.find('.')],file_path[file_path.find('.')+1:]

def file_reader(file_path):
    file_path=file_path
    file=open(file_path,'r')
    data=file.read()
    file.close()
    return data

def file_writer(folder_path,name,ext,data):
    folder_path=folder_path
    files=folder_reader(folder_path,name+"*",ext)
    if files==[]:
        name=name+"0"
    else:
        if (int(''.join(filter(lambda i: i.isdigit(), file_name(files[-1])[1]))) is not len(files)-1):
            for counter,val in enumerate(files):
                if (int(''.join(filter(lambda i: i.isdigit(), file_name(val)[1]))) is not  counter):
                    name=name+str(counter)
                    break
        else:
            name=name+str(len(files))
                      
    file=open(folder_path+name+"."+ext,'a')
    file.write(data)
    file.close()
    
def current_path():
    folder_path=""
    for path in os.getcwd().split('\\'):
        folder_path=folder_path+'/'+path
    #return folder_path[1:]+'\\'   
    return (os.getcwd())+'\\'                         
        
    
if __name__ == "__main__":   
    folder_path=current_path()
    name_input="data_input"
    name_output="encrypt"
    ext='txt'
    files=folder_reader(folder_path,name_input,ext)
    [_,name,_]=file_name(files[0])
    filedata=file_reader(files[0])
    file_writer(folder_path,name_output,ext,filedata)
    #print(files[0])





