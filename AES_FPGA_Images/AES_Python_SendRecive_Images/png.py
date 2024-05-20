import struct
from PIL import Image
import os
from text_uploader import file_name


# Write Packets to PNG (Testing of Packet Reassembly)
def write_packets_to_png(packets, filename):
    i = 0
    while True:
        newfilename = f"{filename}REASSEM{i}.png"
        if not os.path.exists(newfilename):
            break
        i += 1

    with open(newfilename, 'wb') as f:
        for packet in packets:
            f.write((packet))

    print(f"Packets written to {newfilename}")

# Packet Creator, returns array of packets
def split_into_packets(png_file, packet_size):
    packets = []
    ending_sequence = b'\x49\x45\x4E\x44\xAE\x42\x60\x82'
    # Open PNG file
    with open(png_file, "rb") as f:
        data = f.read()
    for i in range(0, len(data), packet_size):
        packet = data[i:i+packet_size]
        if len(packet) < packet_size:
            packet += ending_sequence  # Pad with ending sequence
            print(packet)
        packets.append(packet)
        print(packet.hex())
        print()
    return packets



# Now you can send these packets over the network or save them to files, etc.
# for i, packet in enumerate(packets):
#    print(packet.hex())


def check_png_ending_sequence(filename):
  # Expected ending sequence for PNG files
  expected_ending_sequence = b'\x49\x45\x4E\x44\xAE\x42\x60\x82'.hex()

  # Read the last 8 bytes of the file
  with open(filename, 'rb') as f:
      f.seek(-8, 2)
      ending_bytes = f.read()
      #print(expected_ending_sequence)
      #print(ending_bytes.hex())

  # Compare with the expected ending sequence
  if expected_ending_sequence == ending_bytes.hex():
      print("The ending sequence matches the PNG standard.")
  else:
      print("The ending sequence does not match the PNG standard.")


# Metadata information, Height and Width
def get_png_info(file_path):
      with open(file_path, 'rb') as f:
          # PNG file signature (8 bytes)
          signature = f.read(8)
          if signature != b'\x89PNG\r\n\x1a\n':
              print("Not a valid PNG file.")
              return

          # Read IHDR chunk
          length_bytes = f.read(4)
          length = struct.unpack('!I', length_bytes)[0]
          chunk_type = f.read(4)
          if chunk_type != b'IHDR':
              print("No IHDR chunk found.")
              return
          data = f.read(length)
          width, height = struct.unpack('!II', data[:8])
          print(f"Width: {width}")
          print(f"Height: {height}")


file_name = "image128"
png_file = f"{file_name}.png"

# Height and Width
get_png_info(png_file)


# Split PNG data into packets
packetsArray = split_into_packets(png_file, 128)


# Write packets to PNG file
write_packets_to_png(packetsArray, file_name)
expected_ending_sequence = b'\x49\x45\x4E\x44\xAE\x42\x60\x82'.hex()
print(['49', '45', '4e', '44', 'ae', '42', '60', '82'])
# Check ending sequence
check_png_ending_sequence(png_file)