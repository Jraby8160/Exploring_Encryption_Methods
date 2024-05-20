import serial
import serial.tools.list_ports
import time
import numpy as np


def initialize_port(port_name):
  return serial.Serial(port=port_name, baudrate=9600, bytesize=8, 
                       timeout=None, stopbits=serial.STOPBITS_ONE)



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


senderPortIndex = 4
FPGA=initialize_port(ports_used()[senderPortIndex])


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
  # Define packet size in bytes (128 bits = 16 bytes)
  BITS_PER_BYTE = 8
  packet_size_bytes = 16

  # Calculate packet size in bits
  packet_size_bits = packet_size_bytes * BITS_PER_BYTE

  # Divide image data into packets
  packets = [img_data[i:i + packet_size_bytes] for i in range(0, len(img_data), packet_size_bytes)]

  return packets


def send_data(data):
  print("before sending data: " + str(int(time.time())))
  print(data.hex())
  FPGA.write(data)

  print("after sending data: " + str(int(time.time())))
  time.sleep(0.001)







def main():

  filename = "elaine.pgm"
  required_width = 512  # Change this to your required width
  required_height = 512  # Change this to your required height
  width, height, img_data = read_pgm(filename, required_width, required_height)
  if width is not None and height is not None and img_data is not None:
      print(f"Width: {width}, Height: {height}")
      print("Image data array:")
      # print(img_data)
      packets = parse_image_data(img_data)
      i = 0
      for packet in packets:
          # print(packet)
          send_data(packet)
          i += 1
          print('\t', i)
          time.sleep(.5)


if __name__ == "__main__":
  main()
