<?php

namespace Juspay\Model;

use Juspay\Exception\APIConnectionException;
use Juspay\Exception\APIException;
use Juspay\Exception\AuthenticationException;
use Juspay\Exception\InvalidRequestException;
use Juspay\RequestMethod;
use Juspay\RequestOptions;

/**
 * Class PaymentMethod
 *
 * @property string $paymentMethod
 * @property string $paymentMethodType
 * @property string $description
 *
 * @package Juspay\Model
 */
class PaymentMethod extends JuspayResponse {
    
    
    /**
     *
     * @param string $merchantId
     * @param RequestOptions|null $requestOptions
     *
     * @return PaymentMethodList
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function listAll($merchantId, $requestOptions = null) {
        if ($merchantId == null || $merchantId == "") {
            throw new InvalidRequestException ();
        }
        $response = self::makeServiceCall ( "/merchants/" . $merchantId . "/paymentmethods", null, RequestMethod::GET, $requestOptions );
        $paymentMethods = array ();
        if (array_key_exists ( "payment_methods", $response )) {
            $paymentMethods = $response ["payment_methods"];
            for($i = 0; $i < sizeof ( $paymentMethods ); $i ++) {
                $paymentMethods [$i] = new PaymentMethod( $paymentMethods [$i] );
            }
        }
        return $paymentMethods;
    }
    
}
