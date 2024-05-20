import serial.tools.list_ports
from serial import Serial

# Find available ports
ports = list(serial.tools.list_ports.comports())
print("Available ports:")
for port in ports:
    print(port)

# Create two virtual serial ports
portTX = Serial('COMTX')  # Replace COM10 with desired port name
portRX = Serial('COMRX')  # Replace COM11 with desired port name

try:
    # Open both ports
    portTX.open()
    portRX.open()

    print("Ports opened successfully.")

    # Communication loop
    while True:
        # Read from port1 and write to port2
        if portTX.in_waiting:
            data = portTX.read(portTX.in_waiting)
            portRX.write(data)

        # Read from port2 and write to port1
        if portRX.in_waiting:
            data = portRX.read(portRX.in_waiting)
            portTX.write(data)

except KeyboardInterrupt:
    print("Exiting.")

finally:
    # Close ports
    portTX.close()
    portRX.close()
