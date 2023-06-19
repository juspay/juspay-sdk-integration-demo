<?php
$privateKey = "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAA70vuNEyFLz2FzpPYzwN5aX1rYhPBmS89Yt6pu6McT7jlnw\n-----END RSA PRIVATE KEY-----";

// This is a sample snippet. Always store and fetch the private key from crypto vault

function createSignature($payload, $privateKey) {
    $response = array();
    $requiredFields = ["order_id", "merchant_id", "amount", "timestamp", "customer_id"];
    foreach ($requiredFields as $key){
        if(!array_key_exists($key, $payload)){
            echo $key . " is not present ";
            return;
        }
    }
    $signaturePayload = json_encode($payload);
    $signature = "";
    openssl_sign($signaturePayload, $signature, $privateKey, "sha256WithRSAEncryption");
    array_push($response, base64_encode($signature));
    array_push($response,$signaturePayload);
    return $response;
}
?>