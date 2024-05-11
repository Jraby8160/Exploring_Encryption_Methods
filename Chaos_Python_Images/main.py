import numpy as np
import matplotlib.pyplot as plt
from PIL import Image

def parameter(K):
    Xl = K[1::2]
    XR = K[::2]
    R = np.bitwise_xor(Xl, XR)
    S = np.sum(K)

    bin_to_dec_64 = 2**np.arange(63, -1, -1)
    max_64 = np.sum(bin_to_dec_64) / S

    bin_to_dec_32 = 2**np.arange(31, -1, -1)
    max_32 = np.sum(bin_to_dec_32) / S

    xl = np.zeros(2)
    xr = np.zeros(2)
    r1 = np.zeros(2)
    r2 = np.zeros(2)

    for i in range(2):
        xl[i] = np.mod(np.dot(Xl[i*64:(i+1)*64], bin_to_dec_64) / max_64, 1)
        xr[i] = np.mod(np.dot(XR[i*64:(i+1)*64], bin_to_dec_64) / max_64, 1)
        r1[i] = 0.3 + np.mod(np.dot(R[i*32:(i+1)*32], bin_to_dec_32) / max_32, 0.7)
        r2[i] = 0.3 + np.mod(np.dot(R[i*32+64:(i+1)*32+64], bin_to_dec_32) / max_32, 0.7)

    return xl, xr, r1, r2

def v18(x0, r1, r2):
    flipped_sine = flipped_sine_map(x0, r1)
    sine = sine_map(x0, r2)
    return (flipped_sine + sine) / 2

def flipped_sine_map(x_n, ratio):
    return ratio - ratio * np.sin(np.pi * x_n)

def sine_map(x_n, ratio):
    return ratio * np.sin(np.pi * x_n)

def key_expansion(m, n, r1, r2, Lm, Ln):
    M = np.zeros(Lm)
    N = np.zeros(Ln)
    M[0] = m
    N[0] = n

    for i in range(1, Lm):
        M[i] = v18(M[i-1], r1, r2)
    M = np.ceil(Ln * M).astype(int)

    for j in range(1, Ln):
        N[j] = v18(N[j-1], r2, r1)
    N = np.ceil(Lm * N).astype(int)

    return M, N

def permutation(image, M, N):
    m, n = image.shape
    # Row permutation
    for i in range(m):
        image[i, :] = np.roll(image[i, :], -M[i])
    # Column permutation
    for j in range(n):
        image[:, j] = np.roll(image[:, j], -N[j])
    return image

def substitution(image, M, N, F):
    m, n = image.shape
    image[0, :] = np.mod(image[0, :] + N, F)
    for i in range(1, m):
        image[i, :] = np.mod(image[i, :] + image[i-1, :], F)
    image[:, 0] = np.mod(image[:, 0] + M, F)
    for j in range(1, n):
        image[:, j] = np.mod(image[:, j] + image[:, j-1], F)
    return image

def inverse_permutation(image, M, N):
    m, n = image.shape
    # Column permutation
    for j in range(n):
        image[:, j] = np.roll(image[:, j], N[j])
    # Row permutation
    for i in range(m):
        image[i, :] = np.roll(image[i, :], M[i])
    return image

def inverse_substitution(image, M, N, F):
    m, n = image.shape
    for j in range(n-1, 0, -1):
        image[:, j] = np.mod(image[:, j] - image[:, j-1], F)
    image[:, 0] = np.mod(image[:, 0] - M, F)
    for i in range(m-1, 0, -1):
        image[i, :] = np.mod(image[i, :] - image[i-1, :], F)
    image[0, :] = np.mod(image[0, :] - N, F)
    return image

def load_image(filename):
    return np.array(Image.open(filename), dtype=np.uint8)

def display_image(image_array, title):
    plt.figure()
    plt.imshow(image_array, cmap='gray')
    plt.title(title)
    plt.axis('off')
    plt.show()

# Example usage
filename = 'elaine.pgm'
original_image = load_image(filename)
display_image(original_image, "Original Image")

# Generate a random key (for demonstration, normally it should be fixed for encryption-decryption)
K = np.random.randint(0, 2, size=256)

# Encryption
xl, xr, r1, r2 = parameter(K)
M, N = key_expansion(xl[0], xr[0], r1[0], r2[0], *original_image.shape)
encrypted_image = substitution(permutation(original_image.copy(), M, N), M, N, 256)
display_image(encrypted_image, "Encrypted Image")

# Decryption
M, N = key_expansion(xl[0], xr[0], r1[0], r2[0], *encrypted_image.shape)
decrypted_image = inverse_permutation(inverse_substitution(encrypted_image.copy(), M, N, 256), M, N)
display_image(decrypted_image, "Decrypted Image")
