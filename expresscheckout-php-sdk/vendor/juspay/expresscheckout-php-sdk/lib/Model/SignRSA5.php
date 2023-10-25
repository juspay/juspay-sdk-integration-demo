<?php
namespace Juspay\Model;

use Jose\Factory\JWKFactory;
use Jose\Factory\JWSFactory;
use Jose\Loader;

class SignRSA5 extends ISign {

    public $kid;
    
    /**
    * 
    * @param string $kid private key key id
    */
    public function __construct($kid) {
        $this->kid = $kid;
    }

    /**
    * 
    * @param string $privateKey Key used to sing
    * @param string $payload Payload to be signed
    * @return string Returns signed string
    */
    public function sign($privateKey, $payload) {
        $privateJWKKey = JWKFactory::createFromKey($privateKey);
        return JWSFactory::createJWSToCompactJSON($payload, $privateJWKKey, [ 'alg' => 'RS256', 'kid' => $this->kid ]);
    }

    /**
     * Verify the Signature and return decoded payload
     * @param string $publicKey Key used to verify the signature
     * @param string $signedPayload Payload to be verified and decoded
     * @return string Decoded payload
     */
    public function verifySign($publicKey, $signedPayload) {
        $publicJWKKey = JWKFactory::createFromKey($publicKey);
        $loader = new Loader();
        $jwsDecoded = $loader->loadAndVerifySignatureUsingKey($signedPayload, $publicJWKKey, ['RS256']);
        return json_encode($jwsDecoded->getPayload());
    }
}
?>