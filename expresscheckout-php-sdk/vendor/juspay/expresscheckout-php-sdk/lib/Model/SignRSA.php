<?php
namespace Juspay\Model;

use Jose\Component\Signature\JWSLoader;
use Jose\Component\Signature\JWSVerifier;
use Jose\Component\Core\AlgorithmManager;

use Jose\Component\KeyManagement\JWKFactory;
use Jose\Component\Signature\Algorithm\RS256;
use Jose\Component\Signature\JWSBuilder;
use Jose\Component\Signature\Serializer\CompactSerializer;
use Jose\Component\Signature\Serializer\JWSSerializerManager;

class SignRSA extends ISign {

    public $kid;
    /**
    * 
    * @param string $kid private key key id
    */
    public function __construct(string $kid) {
        $this->kid = $kid;
    }

     /**
     * Signer
     * @param string $privateKey Key used to sing
     * @param string $payload Payload to be signed
     * @return string Returns signed string
     */
    public function sign($privateKey, $payload) {
        $privateJWKKey = JWKFactory::createFromKey($privateKey);
        if (version_compare(phpversion(), '7.2.0', '>=')) {
            $jwsBuilder = new JWSBuilder(
                new AlgorithmManager([new RS256()])
            );
        } else {
            $jwsBuilder = new JWSBuilder(
                null,
                new AlgorithmManager([new RS256()])
            );
        }
        $jws = $jwsBuilder
                ->create()
                ->withPayload($payload)
                ->addSignature($privateJWKKey, ['alg' => 'RS256', 'kid' => $this->kid])
                ->build();
        $serializer = new CompactSerializer();

        return $serializer->serialize($jws, 0); 
    }

    /**
     * Verify the Signature and return decoded payload
     * @param string $publicKey Key used to verify the signature
     * @param string $signedPayload Payload to be verified and decoded
     * @return string Decoded payload
     */
    public function verifySign($publicKey, $signedPayload) {
        $publicJWKKey = JWKFactory::createFromKey($publicKey);
        $jwsVerifier = new JWSVerifier(
            new AlgorithmManager([new RS256()])
        );
        $serializerManager = new JWSSerializerManager([
            new CompactSerializer(),
        ]);
        $jwsLoader = new JWSLoader(
            $serializerManager,
            $jwsVerifier,
            null
        );
        $jws = $jwsLoader->loadAndVerifyWithKey($signedPayload, $publicJWKKey, $signature);
        return $jws->getPayload();
    }
}
?>