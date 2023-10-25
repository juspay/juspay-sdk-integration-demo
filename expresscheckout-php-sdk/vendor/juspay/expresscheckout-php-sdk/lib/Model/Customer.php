<?php

namespace Juspay\Model;

use Juspay\Exception\APIConnectionException;
use Juspay\Exception\APIException;
use Juspay\Exception\AuthenticationException;
use Juspay\Exception\InvalidRequestException;
use Juspay\RequestMethod;
use Juspay\RequestOptions;

/**
 * Class Customer
 *
 * @property string $id
 * @property string $object
 * @property string $firstName
 * @property string $lastName
 * @property string $mobileCountryCode
 * @property string $mobileNumber
 * @property string $emailAddress
 * @property DateTime $dateCreated
 * @property DateTime $lastUpdated
 * @property string $objectReferenceId
 *
 * @package Juspay\Model
 */
class Customer extends JuspayResponse {
    
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
     * @return Customer
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
        $response = self::makeServiceCall ( "/customers", $params, RequestMethod::POST, $requestOptions);
        return new Customer ( $response );
    }
    
    /**
     *
     * @param string $id
     * @param array $params
     * @param RequestOptions|null $requestOptions
     *
     * @return Customer
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function update($id, $params, $requestOptions = null) {
        if ($id == null || $id == "" || $params == null || count ( $params ) == 0) {
            throw new InvalidRequestException ();
        }
        $response = self::makeServiceCall ( "/customers/" . $id, $params, RequestMethod::POST, $requestOptions );
        return new Customer ( $response );
    }
    
    // /**
    //  *
    //  * @param array|null $params
    //  * @param RequestOptions|null $requestOptions
    //  *
    //  * @return CustomerList
    //  *
    //  * @throws APIConnectionException
    //  * @throws APIException
    //  * @throws AuthenticationException
    //  * @throws InvalidRequestException
    //  */
    // public static function listAll($params, $requestOptions = null) {
    //     $response = self::makeServiceCall ( "/customers", $params, RequestMethod::GET, $requestOptions );
    //     return new CustomerList ( $response );
    // }
    
    /**
     *
     * @param string $id
     * @param RequestOptions|null $requestOptions
     *
     * @return Customer
     *
     * @throws APIConnectionException
     * @throws APIException
     * @throws AuthenticationException
     * @throws InvalidRequestException
     */
    public static function get($id, $requestOptions = null) {
        if ($id == null || $id == "") {
            throw new InvalidRequestException ();
        }
        $response = self::makeServiceCall ( "/customers/" . $id, null, RequestMethod::GET, $requestOptions );
        return new Customer ( $response );
    }
}
