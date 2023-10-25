<?php

namespace Juspay\Model;
 abstract class IEnc {

    /**
     * Encrypt the payload
     * @param string $key Key used to encrypt the payload/encrypt the encryption key
     * @param string $plainText Payload to be encrypted
     * @return string Encrypted payload
     */
    abstract public function encrypt($key, $plainText);

     /**
     * Decrypt the encrypted payload
     * @param string $key Key used to decrypt the payload/decrypt the encryption key
     * @param string $encryptedPayload Payload to be decrypted
     * @return string Encrypted payload
     */
    abstract public function decrypt($key, $encryptedPayload);
 }
?>