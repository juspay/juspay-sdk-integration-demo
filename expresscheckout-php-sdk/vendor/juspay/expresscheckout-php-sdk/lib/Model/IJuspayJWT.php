<?php
namespace Juspay\Model;

abstract class IJuspayJWT {
     /**
     *
     * @property string $publicKey
     */
    public $publicKey;

       /**
     *
     * @property string $privateKey
     */
    public $privateKey;
    /**
     * Prepare the payload.
     *
     * @param string $payload The payload to prepare.
     * @return string The prepared payload.
     */
    abstract public function preparePayload($payload);
    /**
     * Consume payload
     * @param string $encPaylaod Encrypted payload
     * @return string Returns the decrypted string
     */
    abstract public function consumePayload($encPaylaod);

    /**
     * Initialize Signer and Encrypter
     * @return void
     */
    abstract public function Initialize();

    /**
     *
     * @property ISign $Sign
     */
    public $Sign;

    /**
     *
     * @property IEnc $Enc
     */
    public $Enc;

}
?>