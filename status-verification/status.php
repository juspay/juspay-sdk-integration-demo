function verify_hmac($params, $secret) {
           $receivedHmac = $params['signature'];
           // UrlEncode key/value pairs
           $encoded_params;
           foreach ($params as $key => $value) {
               if($key!='signature' && $key != 'signature_algorithm') {
                   $encoded_params[urlencode($key)] = urlencode($value);
               }
           }
           ksort($encoded_params);
           $serialized_params = "";
           foreach ($encoded_params as $key => $value) {
               $serialized_params = $serialized_params . $key . "=" . $value . "&";
           }
           $serialized_params = urlencode(substr($serialized_params, 0, -1));
           $computedHmac = base64_encode(hash_hmac('sha256', $serialized_params, $secret, true));
           $receivedHmac = urldecode($receivedHmac);
           return urldecode($computedHmac) == $receivedHmac;
       }