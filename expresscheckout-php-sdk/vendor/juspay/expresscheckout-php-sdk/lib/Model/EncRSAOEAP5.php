<?php
namespace Juspay\Model;

use Jose\Factory\JWEFactory;
use Jose\Factory\JWKFactory;
use Jose\Loader;

class EncRSAOEAP5 extends IEnc {

    public $kid;
    /**
    * 
    * @param string $kid private key key id
    */
    public function __construct($kid) {
        $this->kid = $kid;
    }
     /**
     * Encrypt the payload
     * @param string $publicKey Key used to encrypt the payload/encrypt the encryption key
     * @param string $payload Payload to be encrypted
     * @return string Encrypted payload
     */
    public function encrypt($publicKey, $payload) {
        $publicJWKKey = JWKFactory::createFromKey($publicKey);
        return JWEFactory::createJWEToCompactJSON($payload, $publicJWKKey, [
            'alg' => 'RSA-OAEP-256',    
            'enc' => 'A256GCM',
            'kid' => $this->kid,
        ]);        
    }
     /**
     * Decrypt the encrypted payload
     * @param string $privateKey Key used to decrypt the payload/decrypt the encryption key
     * @param string $encryptedPayload Payload to be decrypted
     * @return string Encrypted payload
     */
    public function decrypt($privateKey, $encryptedPayload) {
        $privateJWKKey = JWKFactory::createFromKey($privateKey);
        $loader = new Loader();
        $decryptedJWE = $loader->loadAndDecryptUsingKey(
            $encryptedPayload,
            $privateJWKKey,
            ['RSA-OAEP-256'],
            ['A256GCM']
        );
        return json_encode($decryptedJWE->getPayload());
    }
}
?>