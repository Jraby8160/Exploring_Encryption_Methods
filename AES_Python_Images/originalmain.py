from aes import AES
import secrets

master_key = 0x2b7e151628aed2a6abf7158809cf4f3c


def test_aes_encryption():
  AES_instance = AES(master_key)
  plaintext = 0x3243f6a8885a308d313198a2e0370734
  expected_encrypted = 0x3925841d02dc09fbdc118597196a0b32

  # Encryption
  encrypted = AES_instance.encrypt(plaintext)
  print(f"Plaintext: {hex(plaintext)}")
  print(f"Encrypted: {hex(encrypted)}")

  # Compare with the expected encrypted value
  if encrypted == expected_encrypted:
    print("Encryption matches the expected result.")
  else:
    print("Encryption does not match the expected result.")


def test_aes_decryption():
  AES_instance = AES(master_key)
  ciphertext = 0x3925841d02dc09fbdc118597196a0b32
  expected_decrypted = 0x3243f6a8885a308d313198a2e0370734

  # Decryption
  decrypted = AES_instance.decrypt(ciphertext)
  print(f"Ciphertext: {hex(ciphertext)}")
  print(f"Decrypted: {hex(decrypted)}")

  # Compare with the expected decrypted value
  if decrypted == expected_decrypted:
    print("Decryption matches the expected result.")
  else:
    print("Decryption does not match the expected result.")


random_key = secrets.token_bytes(16)

# Convert the random_key to a hexadecimal string
hex_key = "0x" + random_key.hex()
print("RNG Key: ", hex_key)
print()


def test_aes_rng(input_text):
  random_key = secrets.token_bytes(16)
  key = int.from_bytes(random_key, byteorder='big')

  print(f"Random Key: {hex(key)}")

  # Create an AES instance with the random key
  aes = AES(key)

  # Truncate the input text to 16 bytes
  input_text = input_text[:16]

  # Convert the input sentence to bytes
  input_bytes = input_text.encode('utf-8')

  # Pad the input bytes if needed to match AES block size
  while len(input_bytes) % 16 != 0:
    input_bytes += b'\x00'

  # Convert the padded input bytes to an integer
  plaintext = int.from_bytes(input_bytes, byteorder='big')

  # Encrypt the plaintext
  ciphertext = aes.encrypt(plaintext)

  # Decrypt the ciphertext
  decrypted = aes.decrypt(ciphertext)
  # Convert an integer back to bytes
  decryptedSentence = decrypted.to_bytes((decrypted.bit_length() + 7) // 8,
                                         byteorder='big')
  print()
  print("Input Sentence: ", input_text)
  print("Plaintext Sentence: ", plaintext)
  print()
  print(f"Ciphertext: {hex(ciphertext)}")
  print()
  print("Decrypted Sentence: ", decrypted)
  print("Output Sentence: ", decryptedSentence.decode('utf-8'))
  # Check if the decrypted text matches the original input bytes
  if decrypted.to_bytes((decrypted.bit_length() + 7) // 8,
                        byteorder='big') == input_bytes:
    print("Encryption and Decryption Successful!")
  else:
    print("Encryption and Decryption Failed!")


def read_pgm_image(filename):
  # Open the PGM image file
  with open(filename, 'rb') as f:
    # Initialize width and height variables
    width = None
    height = None

    # Skip the header information until we reach the pixel data
    while True:
      line = f.readline().decode().strip()
      if line.startswith('255'):
        break
      elif line.startswith('P5') or line.startswith('#'):
        continue
      elif width is None:
        width, height = map(int, line.split())

    # Read the pixel data
    image_data = bytearray(f.read())

  # Convert pixel data into chunks of 128 bits (16 bytes)
  chunk_size = 16
  chunks = [
      image_data[i:i + chunk_size]
      for i in range(0, len(image_data), chunk_size)
  ]
  print(chunks[16351].hex())
  print(chunks[16352].hex())
  print(chunks[16353].hex())
  print(len(chunks))
  return chunks, width, height


def save_pgm_image(filename, image_chunks, width, height):
    with open(filename, 'wb') as f:
        # Write the specified PGM header
        f.write(b'P5\n# CREATOR: XV Version 3.10a+FLmask  Rev: 12/29/94\n')
        f.write(f'{width} {height}\n'.encode())
        f.write(b'255\n')
        # Write the pixel data
        for chunk in image_chunks:
            f.write(chunk)



def encrypt_image_chunks(image_chunks, aes_instance):
  encrypted_chunks = []
  for chunk in image_chunks:
    # Convert the chunk to an integer
    plaintext = int.from_bytes(chunk, byteorder='big')
    encrypted_chunk = aes_instance.encrypt(plaintext)
    # Convert the encrypted integer back to bytes and ensure 16-byte alignment
    encrypted_chunk_bytes = encrypted_chunk.to_bytes(16, byteorder='big')
    encrypted_chunks.append(encrypted_chunk_bytes)
  print('plaintext')
  print(plaintext)
  print("Encryted: ", encrypted_chunks[16351])
  print("Encryted: ", encrypted_chunks[16352])
  print("Encryted: ", encrypted_chunks[16353])
  return encrypted_chunks


def decrypt_image_chunks(encrypted_chunks, aes_instance):
    decrypted_chunks = []
    for chunk in encrypted_chunks:
        # Convert the encrypted chunk from bytes back to an integer
        encrypted_int = int.from_bytes(chunk, byteorder='big')
        decrypted_chunk = aes_instance.decrypt(encrypted_int)
        # Convert the decrypted integer back to bytes, ensuring 16-byte alignment
        decrypted_chunk_bytes = decrypted_chunk.to_bytes(16, byteorder='big')
        decrypted_chunks.append(decrypted_chunk_bytes)
        #print("Decrypted: ", decrypted_chunks[16352].hex())
    return decrypted_chunks


def encrypt_decrypt_pgm_file(input_filename, output_filename, aes_instance):
  # Read the PGM image
  image_chunks, width, height = read_pgm_image(input_filename)
  print(image_chunks[0])
  # Encrypt the image chunks
  encrypted_chunks = encrypt_image_chunks(image_chunks, aes_instance)

  # Decrypt the encrypted image chunks
  decrypted_chunks = decrypt_image_chunks(encrypted_chunks, aes_instance)
  print(decrypted_chunks[0])
  # Save the decrypted image to a new file
  save_pgm_image(output_filename, decrypted_chunks, width, height)


def check_decryption_accuracy(original_chunks, decrypted_chunks):
  if len(original_chunks) != len(decrypted_chunks):
      print("Number of original chunks and decrypted chunks do not match.")
      return

  for i in range(len(original_chunks)):
      original_chunk = original_chunks[i]
      decrypted_chunk = decrypted_chunks[i]
      last = i
      if original_chunk != decrypted_chunk:
          print(f"Chunk {i+1} does not match.")
          print(f"Original: {original_chunk.hex()}")
          print(f"Decrypted: {decrypted_chunk.hex()}")
          

  print("All chunks match.")
  print(last)
  return



if __name__ == '__main__':
  # test_aes_encryption()
  print()
  # test_aes_decryption()
  print()
  print()
  print()
  # input_sentence = input("Enter a sentence: ")
  # test_aes_rng(input_sentence)

  aes_instance = AES(master_key)

  # Encrypt and decrypt the PGM file
  encrypt_decrypt_pgm_file('elaine.pgm', 'decrypted_elaine.pgm', aes_instance)
  print("DONE")
  # In your main code after decryption:
  image_chunks, width, height = read_pgm_image('elaine.pgm')
  encrypted_chunks = encrypt_image_chunks(image_chunks, aes_instance)
  save_pgm_image("testencrypt.pgm", encrypted_chunks, 512, 512)
  # Decrypt the encrypted image chunks
  decrypted_chunks = decrypt_image_chunks(encrypted_chunks, aes_instance)

  # Check decryption accuracy
  check_decryption_accuracy(image_chunks, decrypted_chunks)
  save_pgm_image("decrypt.pgm", decrypted_chunks, 512, 512)
  print(image_chunks)