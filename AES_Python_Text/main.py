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
    decryptedSentence = decrypted.to_bytes((decrypted.bit_length() + 7) // 8, byteorder='big')
    print()
    print("Input Sentence: ", input_text)
    print("Plaintext Sentence: ", plaintext)
    print()
    print(f"Ciphertext: {hex(ciphertext)}")
    print()
    print("Decrypted Sentence: ", decrypted)
    print("Output Sentence: ", decryptedSentence.decode('utf-8'))
    # Check if the decrypted text matches the original input bytes
    if decrypted.to_bytes((decrypted.bit_length() + 7) // 8, byteorder='big') == input_bytes:
        print("Encryption and Decryption Successful!")
    else:
        print("Encryption and Decryption Failed!")


if __name__ == '__main__':
  test_aes_encryption()
  print()
  test_aes_decryption()
  print()
  print()
  print()
  input_sentence = input("Enter a sentence: ")
  test_aes_rng(input_sentence) 
