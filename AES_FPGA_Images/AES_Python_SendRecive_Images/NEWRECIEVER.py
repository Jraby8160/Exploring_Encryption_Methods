

import serial
import serial.tools.list_ports

import time
import text_uploader as fh

functions=locals

rxPortIndex = 0
def ports_used():
    list = serial.tools.list_ports.comports()
    connected = []
    for element in list:
        connected.append(element.device)
    return connected

def print_ports_used(connected):
    print("Connected COM ports: " + str(connected))

def initialize_port(port_name):
    return serial.Serial(port=port_name, baudrate=9600, bytesize=8, 
                         timeout=None, stopbits=serial.STOPBITS_ONE)   

def close_port(device_name):
    eval(device_name+".close()")

def read_data(device_name):
    folder_path=fh.current_path()
    ext="pgm"
    name_output="encrypt"
    folder="data_recieved"
    data_complete= b''  # Image type (P5), width, height, and maximum pixel value
    folder_path=folder_path+"\\"+folder+"\\"
    print("before recieving data: " + str(int(time.time())))
    i = 0
    while True:    
        #fh.file_writer(folder_path,name_output,ext,str(eval(device_name + ".read(8)")))
        data=eval(device_name + ".read(1)")
        print(data.hex())
        i += 1
        if i >= 512*512:
            break
        try:
            print('\t', i)
            data_complete+=data
            # data_complete+=data
        except:
            data_complete=data_complete
    data_complete += data
    # utf8_encoded_data = data_complete.encode('utf-8')
    print("after recieving data: " + str(int(time.time())))
    print(data_complete)
    fh.file_writer(folder_path,name_output,ext,data_complete)
    # some code to display the binary string image


def recieve_data_main():
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[rxPortIndex])
    FPGA=initialize_port(ports_used_array[rxPortIndex])  
    read_data('FPGA')
    close_port('FPGA')

if __name__ == "__main__": 
    ports_used_array=ports_used()
    print(ports_used_array)  
    print_ports_used(ports_used_array[rxPortIndex])
    FPGA=initialize_port(ports_used_array[rxPortIndex])
    read_data('FPGA')
    close_port('FPGA')
    
