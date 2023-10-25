<?php

namespace Juspay\Exception;

class InvalidRequestException extends JuspayException {
    public function __construct($httpResponseCode = null, $status = null, $errorCode = null, $errorMessage = null) {
        if ($httpResponseCode == null) {
            parent::__construct ( 400, "invalid_request", "invalid_request", "Please pass valid arguments." );
        } else {
            parent::__construct ( $httpResponseCode, $status, $errorCode, $errorMessage == null ?  "INVALIDREQUEST EXCEPTION" : $errorMessage );
        }
    }
}