// Sample in c#

using System;
using System.Security.Cryptography;
using System.Text;

public class AES128CBCDecryptor
{
    public static string DecryptAES128CBC(string encryptedData, byte[] key)
    {
        if (key.Length != 16)
        {
            throw new ArgumentException("Key must be 16 bytes (AES-128 requires a 128-bit key).");
        }

        // Extract IV from the encrypted data (first 16 bytes)
        byte[] iv = Encoding.UTF8.GetBytes(encryptedData.Substring(0, 16));
        string base64Data = encryptedData.Substring(16);
        byte[] encryptedBytes = Convert.FromBase64String(base64Data);

        if (encryptedBytes.Length % 16 != 0)
        {
            throw new ArgumentException("Encrypted data length must be a multiple of the block size (16 bytes for AES).");
        }

        using (Aes aes = Aes.Create())
        {
            aes.Key = key;
            aes.IV = iv;
            aes.Mode = CipherMode.CBC;
            aes.Padding = PaddingMode.None;

            using (ICryptoTransform decryptor = aes.CreateDecryptor())
            {
                byte[] decryptedBytes = decryptor.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length);

                // Remove PKCS7 padding
                int paddingLength = decryptedBytes[^1];
                if (paddingLength > 16)
                {
                    throw new ArgumentException("Invalid padding detected.");
                }

                byte[] unpaddedBytes = new byte[decryptedBytes.Length - paddingLength];
                Array.Copy(decryptedBytes, unpaddedBytes, decryptedBytes.Length - paddingLength);

                return Encoding.UTF8.GetString(unpaddedBytes);
            }
        }
    }

    public static void Main(string[] args)
    {
        string encryptedData = "<encrypted_string>";
        byte[] key = Encoding.UTF8.GetBytes("<webhook_key>");

        try
        {
            string decryptedText = DecryptAES128CBC(encryptedData, key);
            Console.WriteLine("Decrypted text: " + decryptedText);
        }
        catch (Exception ex)
        {
            Console.WriteLine("Error during decryption: " + ex.Message);
        }
    }
}
