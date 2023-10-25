<?php
namespace Juspay\Model;
abstract class ISign
{
    /**
     * Signer
     * @param string $key Key used to sing
     * @param string $data Payload to be signed
     * @return string Returns signed string
     */
    abstract public function sign($key, $data);

     /**
     * Verify the Signature and return decoded payload
     * @param string $key Key used to verify the signature
     * @param string $data Payload to be verified and decoded
     * @return string Decoded payload
     */
    abstract public function verifySign($key, $data);
}
?>