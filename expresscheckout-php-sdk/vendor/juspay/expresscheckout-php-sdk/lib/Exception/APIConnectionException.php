<?php

namespace Juspay\Exception;

class APIConnectionException extends JuspayException {
    public function __construct($httpResponseCode, $status, $errorCode, $errorMessage) {
        parent::__construct ( $httpResponseCode, $status, $errorCode, $errorMessage  || "APICONNECTION EXCEPTION");
    }
}