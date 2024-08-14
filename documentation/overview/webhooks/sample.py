import json
from Crypto.Cipher import AES
from base64 import b64decode
msg = json.loads(<encrypted_json_string>)['serialized_response']
iv = msg[:16].encode('utf-8')
decipher = AES.new(<webhook_encryption_key>, AES.MODE_CBC, iv=iv)
cipher_text = b64decode(msg[16:].encode('utf-8'))
data = decipher.decrypt(cipher_text)
event = json.loads(data[:data.rfind('}')+1])
