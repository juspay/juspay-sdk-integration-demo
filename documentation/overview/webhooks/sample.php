// Sample code in PHP

<?php

// webhook_payload => {serialized_response: <encrypted_json_string>}
$str = <encrypted_json_string>;
$key = <webhook_encryption_key>;

$iv = substr($str, 0, 16);
$encry_data = substr($str, 16);
$decry_data = openssl_decrypt($encry_data, "AES-128-CBC", $key, 0, $iv);
print_r($decry_data);

// parse json string to obj
$obj = json_decode($decry_data);
print_r($obj);

?>
