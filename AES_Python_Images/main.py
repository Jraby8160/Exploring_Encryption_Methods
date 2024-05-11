import numpy as np
import matplotlib.pyplot as plt
from aes import AES
import secrets

# Function to display images using matplotlib
def display_image(data, width, height, title):
    image_array = np.array(data).reshape((height, width))
    plt.figure()
    plt.imshow(image_array, cmap='gray')
    plt.title(title)
    plt.axis('off')
    plt.show()

# Function to convert image chunks to integers, encrypt them, and convert back to bytes
def encrypt_image_chunks(image_chunks, aes_instance):
    encrypted_chunks = bytearray()
    for chunk in image_chunks:
        if len(chunk) < 16:
            chunk += b'\x00' * (16 - len(chunk))  # Pad chunks to ensure they are 16 bytes
        plaintext = int.from_bytes(chunk, byteorder='big')
        encrypted = aes_instance.encrypt(plaintext)
        encrypted_chunks.extend(encrypted.to_bytes(16, byteorder='big'))
    return encrypted_chunks

# Function to decrypt image chunks and convert them back to bytes
def decrypt_image_chunks(encrypted_chunks, aes_instance):
    decrypted_chunks = bytearray()
    for i in range(0, len(encrypted_chunks), 16):
        chunk = encrypted_chunks[i:i+16]
        ciphertext = int.from_bytes(chunk, byteorder='big')
        decrypted = aes_instance.decrypt(ciphertext)
        decrypted_chunks.extend(decrypted.to_bytes(16, byteorder='big'))
    return decrypted_chunks

# Function to read a PGM image file into chunks
def read_pgm_image(filename):
    with open(filename, 'rb') as f:
        assert f.readline() == b'P5\n'
        # Skip comments in the header
        line = f.readline()
        while line.startswith(b'#'):
            line = f.readline()
        width, height = map(int, line.split())
        depth = int(f.readline().strip())
        assert depth <= 255

        image_data = bytearray(f.read())
        chunks = [image_data[i:i + 16] for i in range(0, len(image_data), 16)]
    return chunks, width, height, image_data

# Main function to process the PGM image file for encryption and decryption
def process_image_file(input_filename, aes_instance):
    image_chunks, width, height, original_data = read_pgm_image(input_filename)
    display_image(original_data, width, height, "Original Image")

    encrypted_chunks = encrypt_image_chunks(image_chunks, aes_instance)
    display_image(encrypted_chunks, width, height, "Encrypted Image")

    decrypted_chunks = decrypt_image_chunks(encrypted_chunks, aes_instance)
    display_image(decrypted_chunks, width, height, "Decrypted Image")

if __name__ == '__main__':
    master_key = 0x2b7e151628aed2a6abf7158809cf4f3c
    aes_instance = AES(master_key)

    # Example usage with a PGM file
    process_image_file('elaine.pgm', aes_instance)
