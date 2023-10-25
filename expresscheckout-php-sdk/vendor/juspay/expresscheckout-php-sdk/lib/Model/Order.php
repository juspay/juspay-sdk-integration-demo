<?php

namespace Juspay\Model;

use Juspay\Exception\APIConnectionException;
use Juspay\Exception\APIException;
use Juspay\Exception\AuthenticationException;
use Juspay\Exception\InvalidRequestException;
use Juspay\JuspayEnvironment;
use Juspay\RequestMethod;
use Juspay\RequestOptions;

/**
 * Class Order
 *
 * @property string $id
 * @property string $orderId
 * @property string $merchantId
 * @property string $txnId
 * @property float $amount
 * @property string $currency
 * @property string $customerId
 * @property string $customerEmail
 * @property string $customerPhone
 * @property string $description
 * @property string $productId
 * @property int $gatewayId
 * @property string $returnUrl
 * @property string $udf1
 * @property string $udf2
 * @property string $udf3
 * @property string $udf4
 * @property string $udf5
 * @property string $udf6
 * @property string $udf7
 * @property string $udf8
 * @property string $udf9
 * @property string $udf10
 * @property string $status
 * @property int $statusId
 * @property bool $refunded
 * @property float $amountRefunded
 * @property string $bankErrorCode
 * @property string $bankErrorMessage
 * @property string $paymentMethodType
 * @property string $paymentMethod
 *
 * @package Juspay\Model
 */
class Order extends JuspayResponse {
    
    /**
     * Constructor
     *
     * @param array $params
     */


   
    /**
     *
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Order
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
        $response = self::makeServiceCall ( "/order/create", $params, RequestMethod::POST, $requestOptions );
        $response = self::addInputParamsToResponse ( $params, $response );
        $response = self::updateOrderResponseStructure ( $response );
        return new Order ( $response );
    }
    
    /**
     *
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Order
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function status($params, $requestOptions = null) {
        if ($params == null || count ( $params ) == 0) {
            throw new InvalidRequestException ();
        }
        if (($requestOptions != null && $requestOptions->JuspayJWT != null) || JuspayEnvironment::getJuspayJWT() != null) {
            return self::encryptedOrderStatus($params, $requestOptions);
        }
        $response = self::makeServiceCall ( "/order/status", $params, RequestMethod::GET, $requestOptions );
        $response = self::updateOrderResponseStructure ( $response );
        return new Order ( $response );
    }
    
    /**
     *
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Order
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function update($params, $orderId, $requestOptions = null) {
        if ($params == null || count ( $params ) == 0 || $orderId == null) {
            throw new InvalidRequestException ();
        }
        $response = self::makeServiceCall ( "/orders/$orderId", $params, RequestMethod::POST, $requestOptions );
        return new Order ( $response );
    }
    
    // /**
    //  *
    //  * @param array|null $params
    //  * @param RequestOptions|null $requestOptions
    //  *
    //  * @return OrderList
    //  *
    //  * @throws APIConnectionException
    //  * @throws APIException
    //  * @throws AuthenticationException
    //  * @throws InvalidRequestException
    //  */
    // public static function listAll($params, $requestOptions = null) {
    //     $response = self::makeServiceCall ( "/order/list", $params, RequestMethod::GET, $requestOptions );
    //     return new OrderList ( $response );
    // }
    
    /**
     *
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Order
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function refund($params, $requestOptions = null) {
        if (($requestOptions != null && $requestOptions->JuspayJWT != null) || JuspayEnvironment::getJuspayJWT() != null) {
            return self::encryptedOrderRefund($params["order_id"], $params, $requestOptions);
        }
        if ($params == null || count ( $params ) == 0) {
            throw new InvalidRequestException ();
        }
        $response = self::makeServiceCall ( "/order/refund", $params, RequestMethod::POST, $requestOptions );
        $response = self::updateOrderResponseStructure ( $response );
        return new Order ( $response );
    }
    
    /**
     * Restructuring the order response.
     *
     * @param array $response
     *
     * @return array
     */
    private static function updateOrderResponseStructure($response) {
        if (array_key_exists ( "card", $response )) {
            $card = $response ["card"];
            $card ["card_exp_month"] = $card ["expiry_month"];
            $card ["card_exp_year"] = $card ["expiry_year"];
            unset ( $card ["expiry_month"] );
            unset ( $card ["expiry_year"] );
        }
        return $response;
    }

     /**
     *
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Order
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    private static function encryptedOrderStatus($params, $requestOptions = null)
    {
        if ($params == null || count($params) == 0) throw new InvalidRequestException();
        $response = self::makeServiceCall("/v4/order-status", $params, RequestMethod::POST, $requestOptions, 'application/json', true);
        return new Order($response);
    }

    /**
     *
     * @param string $orderId
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Order
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    private static function encryptedOrderRefund($orderId, $params, $requestOptions = null)
    {
        if ($params == null || count($params) == 0) throw new InvalidRequestException();
        $response = self::makeServiceCall("/v4/orders/$orderId/refunds", $params, RequestMethod::POST, $requestOptions, 'application/json', true);
        return new Order($response);
    }
}

