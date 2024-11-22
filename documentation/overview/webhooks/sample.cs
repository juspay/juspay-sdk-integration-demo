// Sample code in C#

using System;  
using System.IO;  
using System.Security.Cryptography;  
using System.Text;  

public class WebHookDecrypt
{   
    public static void Main(string[] args) 
    {   
        // webhook_payload => {serialized_response: <encrypted_json_string>}
        string encr_data = <encrypted_json_string>;
        string key = <webhook_encryption_key>; 
        var decr_data = decrypt(ref encr_data, ref key);  

        Console.WriteLine("DeCrypted Text : "+ decr_data);
    }

    public static string decrypt (ref string cipherText, ref string key)
    {
            byte[] iv = new byte[16];  
            byte[] buffer =  Convert.FromBase64String(cipherText.Substring(16));  

            using (Aes aes = Aes.Create())  
            {  
                aes.Key = Encoding.UTF8.GetBytes(key);  
                aes.IV = iv;  
                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);  

                using (MemoryStream memoryStream = new MemoryStream(buffer))  
                {  
                    using (CryptoStream cryptoStream = new CryptoStream((Stream)memoryStream, decryptor, CryptoStreamMode.Read))  
                    {  
                        using (StreamReader streamReader = new StreamReader((Stream)cryptoStream))  
                        {  
                            return streamReader.ReadToEnd();  
                        }  
                    }  
                }  
            }  

    }
}
