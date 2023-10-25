<?php

namespace Juspay;
use Juspay\Model\IJuspayJWT;

class RequestOptions {
    
    /**
     *
     * @property string $apiKey
     */
    private $apiKey;
    
    /**
     * @property string $merchantId
     */
    private $merchantId;

    /**
     * @property string $customerId
    */
    private $customerId;

    /**
     * Constructor
     */
    public function __construct(IJuspayJWT $juspayJWT = null) {
        $this->apiKey = JuspayEnvironment::getApiKey ();
        if ($juspayJWT != null) $this->JuspayJWT = $juspayJWT;
        else $this->JuspayJWT = JuspayEnvironment::getJuspayJWT();
    }
    
    /**
     * Returns a RequestOptions object with default values
     * from JuspayEnvironment object.
     *
     * @return RequestOptions
     */
    public static function createDefault() {
        JuspayEnvironment::init ();
        return new RequestOptions ();
    }
    
    /**
     * Initializes the RequestOptions object with given API Key.
     *
     * @param string $apiKey
     *
     * @return RequestOptions
     */
    public function withApiKey($apiKey) {
        $this->apiKey = $apiKey;
        return $this;
    }
    
    /**
     *
     * @return string
     */
    public function getApiKey() {
        return $this->apiKey;
    }

     /**
     * Initializes the RequestOptions object with given Merchant ID.
     *
     * @param string $merchantId
     *
     * @return RequestOptions
     */
    public function withMerchantId($merchantId) {
        $this->merchantId = $merchantId;
        return $this;
    }
    
    /**
     *
     * @return string
     */
    public function getMerchantId() {
        return $this->merchantId;
    }

      /**
     * Initializes the RequestOptions object with given Customer ID.
     *
     * @param string $customerId
     *
     * @return RequestOptions
     */
    public function withCustomerId($customerId) {
        $this->customerId = $customerId;
        return $this;
    }
    
    /**
     *
     * @return string
     */
    public function getCustomerId() {
        return $this->customerId;
    }

    public $JuspayJWT;
}