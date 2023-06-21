#Python example for HMAC signature verification

python
import urllib
import hmac
import hashlib
import base64

key = 'your_secret_key'
# params := key/value dictionary except `signature`
#           and `signature_algorithm`
# signature := "5ctBJ0vURSTS9awUhbTBXCpUeDEJG8X%252B6c%253D"
# signature_algorithm := "HMAC-SHA256"

encoded_sorted = []
for i in sorted(params.keys()):
    encoded_sorted.append(urllib.quote_plus(i) + '=' + \
      urllib.quote_plus(params.get(i)))

encoded_string = urllib.quote_plus('&'.join(encoded_sorted))
dig = hmac.new(key, \
              msg=encoded_string, \
              digestmod=hashlib.sha256).digest()

assert urllib.quote_plus(base64.b64encode(dig).decode()) == \
       signature