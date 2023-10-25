<?php

namespace Juspay\Model;

use Juspay\Exception\APIConnectionException;
use Juspay\Exception\APIException;
use Juspay\Exception\AuthenticationException;
use Juspay\Exception\InvalidRequestException;
use Juspay\RequestMethod;
use Juspay\RequestOptions;

/**
 * Class Payment
 *
 * @property string $orderId
 * @property string $txnId
 * @property string $status
 * @property string $method
 * @property string $url
 * @property array $params
 *
 * @package Juspay\Model
 */
class Payment extends JuspayResponse {
    
    /**
     *
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Payment
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function create($params, $requestOptions = null) {
        if ($params == null || count ( $params ) == 0) {
            throw new InvalidRequestException ();
        }
        // We will always send it as json in SDK.
        $params ['format'] = "json";
        $response = self::makeServiceCall ( "/txns", $params, RequestMethod::POST, $requestOptions );
        $response = self::updatePaymentResponseStructure ( $response );
        return new Payment ( $response );
    }
    
    /**
     * Restructuring the payment response.
     * Removed unnecessary hierarchy in the response.
     *
     * @param array $response
     *
     * @return array
     */
    private static function updatePaymentResponseStructure($response) {
        $authResp = $response ['payment'] ['authentication'];
        $response ['method'] = $authResp ['method'];
        $response ['url'] = $authResp ['url'];
        if ($response ['method'] == "POST") {
            $response ['params'] = array ();
            foreach ( array_keys ( $authResp ['params'] ) as $key ) {
                $response ['params'] [$key] = $authResp ['params'] [$key];
            }
        }
        unset ( $response ['payment'] );
        return $response;
    }
}

