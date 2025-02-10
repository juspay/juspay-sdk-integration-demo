// Sample code in Node.js

const crypto = require('crypto');
// webhook_payload => {serialized_response: <encrypted_json_string>}
const str = <encrypted_json_string>;
const key = <webhook_encryption_key>;

const algorithm = 'aes-128-cbc';
try {
    const iv = str.substring(0,16);
    const encry_data = str.substring(16, ) ;
    const decipher = crypto.createDecipheriv(algorithm, key, iv);
    decipher.setAutoPadding(true);
    let decry_data = decipher.update(encry_data, 'base64', 'utf8');
    decry_data += decipher.final('utf8');
    console.log(decry_data);

    // parse json string to obj
    let event_obj = JSON.parse(decry_data);
    console.log(event_obj);
}
catch(err) { }
