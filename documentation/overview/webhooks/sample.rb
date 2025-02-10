// Sample code in Ruby

require 'base64'
require 'securerandom'
require 'openssl'

# webhook_payload => {serialized_response: <encrypted_json_string>}
str = <encrypted_json_string>
key = <webhook_encryption_key>

iv = str[0..15]
encry_data = Base64.decode64(str[16..-1])
decipher = OpenSSL::Cipher::AES.new(128, :CBC)
decipher.decrypt
decipher.key = key
decipher.iv = iv
decry_data = decipher.update(encry_data) + decipher.final

# parse json string to obj
event_obj = JSON.parse(decry_data)
