

import serial
import serial.tools.list_ports
import time
import text_uploader as fh


functions=locals
def ports_used():
    list = serial.tools.list_ports.comports()
    connected = [1]
    for element in list:
        connected.append(element.device)
    return connected

def print_ports_used(connected):
    print("Connected COM ports: " + str(connected))
    
def initialize_port(port_name):
    return serial.Serial(port=port_name, baudrate=9600, bytesize=8, timeout=None, stopbits=serial.STOPBITS_ONE)    

def close_port(device_name):
    eval(device_name+".close()")

def read_data(device_name):
    folder_path=fh.current_path()
    ext="txt"
    name_output="encrypt"
    folder="data_recieved"
    data_complete=""
    folder_path=folder_path+"\\"+folder+"\\"
    print(folder_path)
    print("before recieving data: " + str(int(time.time())))
    
    while True:    
        #fh.file_writer(folder_path,name_output,ext,str(eval(device_name + ".read(8)")))
        data=eval(device_name + ".read(1)")
        print(data)
        print(data_complete)
        if data==b'\xff':
            break
        else:
            try:
                data_complete+=data.decode()
                print(data.decode())
            except:
                data_complete=data_complete

    print("after recieving data: " + str(int(time.time())))
    fh.file_writer(folder_path,name_output,ext,data_complete)
    

    
def recieve_data_main():
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[1])
    FPGA=initialize_port(ports_used_array[1])  
    read_data('FPGA')
    close_port('FPGA')
    
if __name__ == "__main__":   
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[1])
    FPGA=initialize_port(ports_used_array[1])
    read_data('FPGA')
    close_port('FPGA')

