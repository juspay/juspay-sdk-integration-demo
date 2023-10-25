<?php

namespace Juspay\Model;

use Juspay\Exception\APIConnectionException;
use Juspay\Exception\APIException;
use Juspay\Exception\AuthenticationException;
use Juspay\Exception\InvalidRequestException;
use Juspay\RequestMethod;
use Juspay\RequestOptions;

/**
 * Class Card
 *
 * @property string $cardNumber
 * @property string $nameOnCard
 * @property string $cardExpYear
 * @property string $cardExpMonth
 * @property string $cardSecurityCode
 * @property string $nickname
 * @property string $cardToken
 * @property string $cardReference
 * @property string $cardFingerprint
 * @property string $cardIsin
 * @property string $lastFourDigits
 * @property string $cardType
 * @property string $cardIssuer
 * @property bool $savedToLocker
 * @property bool $expired
 * @property string $cardBrand
 *
 * @package Juspay\Model
 */
class Card extends JuspayResponse {
    
    
    // /**
    //  *
    //  * @param array $params
    //  * @param RequestOptions|null $requestOptions
    //  *
    //  * @return Card
    //  *
    //  * @throws APIConnectionException
    //  * @throws APIException
    //  * @throws AuthenticationException
    //  * @throws InvalidRequestException
    //  */
    // public static function create($params, $requestOptions = null) {
    //     if ($params == null || count ( $params ) == 0) {
    //         throw new InvalidRequestException ();
    //     }
    //     $response = self::makeServiceCall ( '/card/add', $params, RequestMethod::POST, $requestOptions );
    //     return new Card ( $response );
    // }
    
    // /**
    //  *
    //  * @param array $params
    //  * @param RequestOptions|null $requestOptions
    //  *
    //  * @return array
    //  *
    //  * @throws APIConnectionException
    //  * @throws APIException
    //  * @throws AuthenticationException
    //  * @throws InvalidRequestException
    //  */
    // public static function listAll($params, $requestOptions = null) {
    //     if ($params == null || count ( $params ) == 0) {
    //         throw new InvalidRequestException ();
    //     }
    //     $response = self::makeServiceCall ( '/cards', $params, RequestMethod::GET, $requestOptions );
    //     $cardArray = array ();
    //     if (array_key_exists ( "cards", $response )) {
    //         $cardArray = $response ["cards"];
    //         for($i = 0; $i < sizeof ( $cardArray ); $i ++) {
    //             $cardArray [$i] = new Card ( $cardArray [$i] );
    //         }
    //     }
    //     return $cardArray;
    // }
    
    // /**
    //  *
    //  * @param array $params
    //  * @param RequestOptions|null $requestOptions
    //  *
    //  * @return bool
    //  *
    //  * @throws APIConnectionException
    //  * @throws APIException
    //  * @throws AuthenticationException
    //  * @throws InvalidRequestException
    //  */
    // public static function delete($params, $requestOptions = null) {
    //     if ($params == null || count ( $params ) == 0) {
    //         throw new InvalidRequestException ();
    //     }
    //     $response = self::makeServiceCall ( '/card/delete', $params, RequestMethod::POST, $requestOptions );
    //     return $response ["deleted"];
    // }
}
