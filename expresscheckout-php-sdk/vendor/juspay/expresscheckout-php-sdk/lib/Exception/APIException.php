<?php

namespace Juspay\Exception;

class APIException extends JuspayException {
    public function __construct($httpResponseCode, $status, $errorCode, $errorMessage) {
        parent::__construct ( $httpResponseCode, $status, $errorCode, $errorMessage || "API EXCEPTION" );
    }
}
