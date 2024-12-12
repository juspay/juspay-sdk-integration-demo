## Package needed: pip install cryptography


from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
import base64

def decrypt_aes_128_cbc(encrypted_data: str, key: bytes) -> str:
    iv = encrypted_data[:16].encode('utf-8')

    data = encrypted_data[16:]

    encrypted_bytes = base64.b64decode(data)

    if len(key) != 16:
        raise ValueError("Key must be 16 bytes (AES-128 requires a 128-bit key).")

    if len(encrypted_bytes) % 16 != 0:
        raise ValueError("Encrypted data length must be a multiple of the block size (16 bytes for AES).")

    # Create the AES-128-CBC cipher
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=default_backend())
    decryptor = cipher.decryptor()

    # Decrypt the data
    decrypted_data = decryptor.update(encrypted_bytes) + decryptor.finalize()

    padding_length = decrypted_data[-1]
    if padding_length > 16:  # Invalid padding
        raise ValueError("Invalid padding detected.")
    decrypted_data = decrypted_data[:-padding_length]

    return decrypted_data.decode('utf-8')

if __name__ == "__main__":
    key = b"<webhook_key>"

    encrypted_data = "<encrypted_string>"

    try:
        decrypted_text = decrypt_aes_128_cbc(encrypted_data, key)
        print("Decrypted text:", decrypted_text)
    except Exception as e:
        print("Error during decryption:", e)
