import serial
import serial.tools.list_ports
import time
import text_uploader as fh

senderPortIndex = 2
functions=locals
def ports_used():
    list = serial.tools.list_ports.comports()
    print('list')
    connected = []
    print(list)
    for element in list:
        connected.append(element.device)
    print('connected')
    print(connected)
    return connected

def print_ports_used(connected):
    print("Connected COM ports: " + str(connected))
    
def initialize_port(port_name):
    return serial.Serial(port=port_name, baudrate=9600, bytesize=8, 
                         timeout=None, stopbits=serial.STOPBITS_ONE)    

def close_port(device_name):
    device_name.close()

def data_string(data_file_name,ext):
    path=fh.current_path()
    folder="data_to_send"
    path='/Users/parkermaner/Hardware_AES_Encryption_Decryption/python/data_to_send/'
    return fh.file_reader(path+data_file_name+"."+ext)


# PGM FUNCTIONS
def read_pgm(filename, required_width, required_height):
  with open(filename, 'rb') as f:
      # Read and validate the header
      header = f.readline().decode('utf-8').strip()
      if header != 'P5':
          print("Error: Not a PGM file.")
          return None, None, None

      # Skip comments
      while True:
          line = f.readline().decode('utf-8').strip()
          if not line.startswith('#'):
              break

      # Read width, height, and max pixel value
      width, height = map(int, line.split())
      max_pixel_value = int(f.readline().decode('utf-8').strip())

      # Check for invalid max pixel value
      if max_pixel_value > 255:
          print("Error: Unsupported max pixel value.")
          return None, None, None

      # Verify image size
      if width != required_width or height != required_height:
          print(f"Error: Image size is not {required_width}x{required_height}.")
          return None, None, None

      # Read image data
      img_data = bytearray(f.read())

  return width, height, img_data

def parse_image_data(img_data):
  packet_size = 128  # Set packet size to 128 bits
  packets = [img_data[i:i+packet_size//8] for i in range(0, len(img_data), packet_size//8)]
  return packets

# END PGM FUNCTIONS

def send_data(data):
    
    
    print("before sending data: " + str(int(time.time())))
    FPGA.write(data)

    print("after sending data: " + str(int(time.time())))
    # Delay?
 

def data_fixer(data):
    data=data.encode()
    return data+b'\xff'*(16-len(data)%16)

def data_decoder(data):
    for i in range(len(data)):
        if data[i]==255:
            break
    data=data[:i].decode()
    return data
    
def ascii_data(data):
    try:
        return ([hex(ord(i)) for i in data])
    except:
        data=data_decoder(data)
        return ([hex(ord(i)) for i in data])




def send_data_main():   
    filename='data_input'
    ext='txt'
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[senderPortIndex])
    filedata=data_string(filename,ext)
    data=data_fixer(filedata)
    send_data(data)
    # print(data)
    # print(ascii_data(data))  
    
if __name__ == "__main__":   
    filename='data_input'
    ext='txt'
    ports_used_array=ports_used()
    print_ports_used(ports_used_array[senderPortIndex])
    filedata=data_string(filename,ext)
    # Split PNG data into packets
    # file_name = "imagefull"
    # png_file = f"{file_name}.png"
    # packetsArray = split_into_packets(png_file, 128)
    #filedata="The art of code"
    data=data_fixer(filedata)
    # i = 1
    FPGA=initialize_port(ports_used()[senderPortIndex])

    filename = "elaine.pgm"
    required_width = 512  # Change this to your required width
    required_height = 512  # Change this to your required height
    width, height, img_data = read_pgm(filename, required_width, required_height)
    if width is not None and height is not None and img_data is not None:
        print(f"Width: {width}, Height: {height}")
        print("Image data array:")
        # print(img_data)
        packets = parse_image_data(img_data)
        for index, packet in enumerate(packets):
            send_data(packet)
            print(index)
            # print(packet)
    # for packet in packetsArray:
    #   send_data(packet)
    #   print(i, packet)
    #   i += 1
    close_port(FPGA)
    #send_data(data)
    #print(data)
    #print(ascii_data(data))    
    print_ports_used(ports_used_array[senderPortIndex])
    




    
