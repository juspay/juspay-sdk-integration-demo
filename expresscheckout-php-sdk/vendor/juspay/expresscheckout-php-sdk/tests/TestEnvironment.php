<?php

namespace Juspay\Test;

use Juspay\JuspayEnvironment;

class TestEnvironment {
    public function __construct() {
        self::$merchantId = getenv('MERCHANT_ID');
        self::$apiKey = getenv('API_KEY');
    }
    public static $merchantId;
    public static $apiKey;
    public static $baseUrl = JuspayEnvironment::SANDBOX_BASE_URL;
}

new TestEnvironment();
JuspayEnvironment::init ()
->withApiKey ( TestEnvironment::$apiKey )
->withBaseUrl ( TestEnvironment::$baseUrl );