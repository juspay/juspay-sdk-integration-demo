<?php

namespace Juspay\Exception;

class AuthenticationException extends JuspayException {
    public function __construct($httpResponseCode, $status, $errorCode, $errorMessage) {
        parent::__construct ( $httpResponseCode, $status, $errorCode, $errorMessage || "AUTHENTICATION EXCEPTION" );
    }
}