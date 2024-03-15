<?php
namespace PaymentHandler;

use DateTime;
use DateTimeZone;
use Exception;
use RuntimeException;

class PaymentHandler {

    /**
     * @property PaymentHandlerConfig $paymentHandlerConfig
     */
    public $paymentHandlerConfig;
    public function __construct($configPath,  $paymentHandlerConfig = null) {
        if ($paymentHandlerConfig != null) {
            $this->paymentHandlerConfig = $paymentHandlerConfig;
        } else {
            $config = file_get_contents(normalizePath($configPath));
            $config = json_decode($config, true);
            $merchantId = null;
            if (array_key_exists("MERCHANT_ID", $config)) {
                $merchantId = $config["MERCHANT_ID"];
            } else {
                throw new RuntimeException("MERCHANT ID NOT FOUND IN CONFIG");
            }
            $apiKey = null;
            if (array_key_exists("API_KEY", $config)) {
                $apiKey = $config["API_KEY"];
            } else {
                throw new RuntimeException("API_KEY NOT FOUND IN CONFIG");
            }
            $paymentPageClientId = null;
            if (array_key_exists("PAYMENT_PAGE_CLIENT_ID", $config)) {
                $paymentPageClientId = $config["PAYMENT_PAGE_CLIENT_ID"];
            }
            $baseUrl = null;
            if (array_key_exists("BASE_URL", $config)) {
                $baseUrl = $config["BASE_URL"];
            }
            $enableLogging = false;
            if (array_key_exists("ENABLE_LOGGING", $config)) {
                $enableLogging = $config["ENABLE_LOGGING"];
            }
            $loggingPath = "logs\\PaymentHandler.log";
            if (array_key_exists("LOGGING_PATH", $config)) {
                $loggingPath = $config["LOGGING_PATH"];
            }
            $responseKey = null;
            if (array_key_exists("RESPONSE_KEY", $config)) {
                $responseKey = $config["RESPONSE_KEY"];
            }
            $caPath = null;
            if (array_key_exists("CA_PATH", $config)) {
                $caPath = $config["CA_PATH"];
            }
            $this->paymentHandlerConfig = PaymentHandlerConfig::getInstance()->withInstance($merchantId, $apiKey, $paymentPageClientId, $baseUrl, $enableLogging, $loggingPath, $responseKey, $caPath);
        }
    }

    /**
     * @param array $params
     * @return array
     */
    public function orderStatus($orderId) {
        $apiTag = "ORDER_STATUS";
        return PaymentEntity::makeServiceCall ( "/orders/{$orderId}", null, RequestMethod::GET, $apiTag);
    }

    /**
     * @param array $params
     * @return array
     */

    // block:start:session-function
    public function orderSession($params) {
        $this->paramsCheck($params);
        $apiTag = "ORDER_SESSION";
        if (!array_key_exists("payment_page_client_id", $params)) {
            $params["payment_page_client_id"] = $this->paymentHandlerConfig->getPaymentPageClientId();
        }
        return PaymentEntity::makeServiceCall ( "/session", $params, RequestMethod::POST, $apiTag, ContentType::JSON);
    }
    // block:end:session-function

    /**
     * @param array $params
     * @return array
     */
    public function refund($params) {
        $this->paramsCheck($params);
        $apiTag = "ORDER_REFUND";
        return PaymentEntity::makeServiceCall("/refunds", $params, RequestMethod::POST, $apiTag, ContentType::X_WWW_FORM_URLENCODED);
    }

    public function validateHMAC_SHA256($params, $secret = null) {
        try {
            if ($secret === null) {
                $secret = $this->paymentHandlerConfig->getResponseKey();
            }
            if ($secret == null) return false;
            $paramsList = [];
            $paramsString = "";
            $expectedHash = null;
            foreach ($params as $key => $value) {
                if ($key != "signature" && $key != 'signature_algorithm') {
                    $paramsList[$key] = $value;
                } else if ($key == "signature") {
                    $expectedHash = urldecode($value);
                }
            }
            ksort($paramsList);
            foreach ($paramsList as $key => $value) {
                $paramsString = $paramsString . $key . "=" . $value . "&";
            }
            $paramsString = urlencode(substr($paramsString, 0, strlen($paramsString) - 1));
            $hash = base64_encode(hash_hmac("sha256", $paramsString, $secret, true));
            if (urldecode($hash) == $expectedHash) return true;
            else {
                $logger = new SimpleLogger();
                $logger->info(json_encode(["computeHash" => urldecode($hash), "expectedHash" => $expectedHash]));
                return false;
            }
        } catch (Exception $e) {
            $logger = new SimpleLogger();
            $logger->info($e->getMessage());
            return false;
        }
    }

    private function paramsCheck($params) {
        if ($params == null || count ( $params ) == 0) {
            throw new APIException (-1, "INVALID_PARAMS", "INVALID_PARAMS", "Params is empty");
        }
    }


}

class PaymentEntity {

    private static function http_parse_headers( $raw_headers ) {
        $headers = array();
        $key = '';

        foreach(explode("\n", $raw_headers) as $i => $h) {
            $h = explode(':', $h, 2);

            if (isset($h[1])) {
                if (!isset($headers[$h[0]])) {
                    if ($h[0] == 'x-response-id') {
                        $headers[$h[0]] = trim($h[1]);
                        break;
                    }
                }
            }
        }
        
        return $headers;
    }
    
    /**
     *
     * @param string $path
     * @param array|null $params
     * @param string $method
     * @param string $contentType
     * @return array
     *
     * @throws APIException
     */
    public static function makeServiceCall($path, $params, $method, $apiTag, $contentType = null) {
        $logger = new SimpleLogger();
        $paymentRequestId = uniqid();
        $paymentHandlerConfig = PaymentHandlerConfig::getInstance();
        $url = $paymentHandlerConfig->getBaseUrl() . $path;
        $curlObject = curl_init ();
        $log = array();
        curl_setopt ( $curlObject, CURLOPT_RETURNTRANSFER, true );
        curl_setopt ( $curlObject, CURLOPT_HEADER, true );
        curl_setopt ( $curlObject, CURLOPT_NOBODY, false );
        curl_setopt ( $curlObject, CURLOPT_USERPWD, $paymentHandlerConfig->getApiKey () );
        curl_setopt ( $curlObject, CURLOPT_HTTPAUTH, CURLAUTH_BASIC );
        curl_setopt ( $curlObject, CURLOPT_USERAGENT,  "SAMPLE_KIT/" . $paymentHandlerConfig->getMerchantId());
        $headers = array('version: ' . $paymentHandlerConfig->getAPIVersion());
        if ($paymentHandlerConfig->getMerchantId()) array_push($headers, 'x-merchantid:'. $paymentHandlerConfig->getMerchantId());
        
        if ($method == RequestMethod::GET) {
            curl_setopt ( $curlObject, CURLOPT_HTTPHEADER, $headers);
            curl_setopt ( $curlObject, CURLOPT_HTTPGET, 1 );
            $log["method"] = "GET";
            if ($params != null) {
                $encodedParams = http_build_query ( $params );
                if ($encodedParams != null && $encodedParams != "") {
                    $url = $url . "?" . $encodedParams;
                }
            }
        } else if ($contentType == ContentType::JSON) {
            array_push( $headers, 'Content-Type: application/json' );
            curl_setopt ( $curlObject, CURLOPT_HTTPHEADER, $headers);
            curl_setopt ( $curlObject, CURLOPT_POST, 1 );
            $log["method"] = "POST";
            if ($params != null) {
                $encodedParams = json_encode($params);
                $log["request_params"] = $encodedParams;
                curl_setopt ( $curlObject, CURLOPT_POSTFIELDS, $encodedParams );
            }
        } else {
            array_push( $headers, 'Content-Type: application/x-www-form-urlencoded' );
            
            curl_setopt ( $curlObject, CURLOPT_HTTPHEADER, $headers);
        
            curl_setopt ( $curlObject, CURLOPT_POST, 1 );
            $log["method"] = "POST";
            if ($params != null) {
                $body = http_build_query($params);
                $log["request_params"] = $body;
                curl_setopt ( $curlObject, CURLOPT_POSTFIELDS, $body);
            }
        }
        $log["headers"] = $headers;
        $logger->setLoggerContext(array("api_tag" => $apiTag, "payment_request_id" => $paymentRequestId));
        $logger->info("Executing Request:".$url);
        $logger->info("Request:".json_encode($log));
        curl_setopt ( $curlObject, CURLOPT_URL, $url );
        $ca = ini_get('curl.cainfo');
        $ca = $ca === null || $ca === "" ? ini_get('openssl.cafile') : $ca;
        if ($ca === null || $ca === "") {
            $caCertificatePath = PaymentHandlerConfig::getInstance()->getCacert();
            curl_setopt ($curlObject, CURLOPT_CAINFO, $caCertificatePath);
        }
        $response = curl_exec ( $curlObject );
        if ($response == false) {
            $curlError = curl_error ( $curlObject );
            $logger->error('connection error:'. $curlError);
            throw new APIException ( - 1, "connection_error", "connection_error",  $curlError);
        } else {
            $log = array();
            $responseCode = curl_getinfo ( $curlObject, CURLINFO_HTTP_CODE );
            $headerSize = curl_getinfo ( $curlObject, CURLINFO_HEADER_SIZE );
            $encodedResponse = substr ( $response, $headerSize );
            $responseBody = json_decode ($encodedResponse, true );
            $responseHeaders = self::http_parse_headers(substr($response, 0, $headerSize));
            
            $log = [ "http_status_code" => $responseCode,  "response" => $encodedResponse, "response_headers" => json_encode($responseHeaders)];
            curl_close ( $curlObject );
            if ($responseCode >= 200 && $responseCode < 300) {
                $logger->info("Received response:" . json_encode($log));
                return $responseBody;
            } else {
                $status = null;
                $errorCode = null;
                $errorMessage = null;
                if ($responseBody != null) {
                    if (array_key_exists ( "status", $responseBody ) != null) {
                        $status = $responseBody ['status'];
                    }
                    if (array_key_exists ( "error_code", $responseBody ) != null) {
                        $errorCode = $responseBody ['error_code'];
                    }
                    if (array_key_exists ( "error_message", $responseBody ) != null) {
                        $errorMessage = $responseBody ['error_message'];
                    } else {
                        $errorMessage = $status;
                    }
                }
                $logger->error("Received response:" . json_encode($log));
                throw new APIException ( $responseCode, $status, $errorCode, $errorMessage );
            }
        }
    }
    
}
class APIException extends Exception {
    private $httpResponseCode;
    private $status;
    private $errorCode;
    private $errorMessage;
    public function __construct($httpResponseCode, $status, $errorCode, $errorMessage) {
        parent::__construct ( $errorMessage == null ? "Something went wrong" : $errorMessage );
        $this->httpResponseCode = $httpResponseCode;
        $this->status = $status;
        $this->errorCode = $errorCode;
        $this->errorMessage = $errorMessage;
    }
    public function getHttpResponseCode() {
        return $this->httpResponseCode;
    }
    public function getStatus() {
        return $this->status;
    }
    public function getErrorCode() {
        return $this->errorCode;
    }
    public function getErrorMessage() {
        return $this->errorMessage;
    }
}

class PaymentHandlerConfig {
    /**
     * @property PaymentHandlerConfig $instance
     */
    private static $instance;
    private function __construct() {}

    public function __destruct() {
       $this->closeLogFileHandler();
    }
    /**
     * @property string $apiKey
     */
    private $apiKey;

    /**
     * @property string $merchantId
     */
    private $merchantId;


    /**
     * @property string $paymentPageClientId
     */
    private $paymentPageClientId;

    /**
     * @property string $baseUrl
     */
    private $baseUrl;

     /**
     * @property bool $enableLogging
     */
    private $enableLogging;

      /**
     * @property string $loggingPath
     */
    private  $loggingPath;

      /**
     * @property string $responseKey
     */
    
    private $responseKey;

    /**
     * @property string $API_VERSION
     */
    private $API_VERSION = "2024-02-01";

    /**
     * @property resource $logFileHandle
     */
    private $logFileHandle;

    /**
     * @property string $cacert
     */
    private $cacert;

    /**
     * @param string $merchantId
     * @param string $apiKey
     * @param string $paymentPageClientId
     * @param string $baseUrl
     * @param bool   $enableLogging
     * @param string $loggingPath
     * @param string $responseKey
     * @return PaymentHandlerConfig
     */
    public function withInstance($merchantId = null, $apiKey = null, $paymentPageClientId = null, $baseUrl = null, $enableLogging = null, $loggingPath = null, $responseKey = null, $caPath = null) {
        $this->apiKey = $apiKey;
        $this->merchantId = $merchantId;
        $this->paymentPageClientId = $paymentPageClientId;
        $this->baseUrl = $baseUrl;
        $this->enableLogging = $enableLogging;
        $this->loggingPath = normalizePath($loggingPath);
        $this->setLogFileHandler();
        $this->responseKey = $responseKey;
        $this->withCacert($caPath);
        return $this;
    }

    public function closeLogFileHandler() {
        if ($this->logFileHandle !== null) {
            try {
                fclose($this->logFileHandle);
                $this->logFileHandle = null;
            } catch (Exception $e) {
                $this->logFileHandle = null;
            }
        }
    }

    /**
     * @return PaymentHandlerConfig
     */
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * @return string
     */
    public function getApiKey() {
        return $this->apiKey;
    }

     /**
     * @return string
     */
    public function getMerchantId() {
        return $this->merchantId;
    }

     /**
     * @return string
     */
    public function getPaymentPageClientId() {
        return $this->paymentPageClientId;
    }

     /**
     * @return string
     */
    public function getBaseUrl() {
        return $this->baseUrl;
    }

     /**
     * @return bool
     */
    public function getEnableLogging() {
        return $this->enableLogging;
    }

     /**
     * @return string
     */
    public function getLoggingPath() {
        return $this->loggingPath;
    }

     /**
     * @return string
     */
    public function getResponseKey() {
        return $this->responseKey;
    }

     /**
     * @return string
     */
    public function getAPIVersion() {
        return $this->API_VERSION;
    }

    /**
     * @return resource
     */
    public function getLogFileHandle() {
        return $this->logFileHandle;
    }

     /**
     * @return string
     */
    public function getCacert() {
        return $this->cacert;
    }


    /**
     * @param string $apiVersion
     */
    public function withAPIVersion($apiVersion) {
        $this->API_VERSION = $apiVersion;
    }

    /**
     * @param string $cacertPath
     */
    public function withCacert($cacertPath) {
        if ($cacertPath !== null) { 
            $this->cacert = normalizePath($cacertPath);
            if (!file_exists($this->cacert)) {
                throw new RuntimeException("CA File Not Found");
            }
        }
    }

    public function setLogFileHandler() {
        $this->closeLogFileHandler();
        try {
            if ($this->loggingPath !== null && $this->enableLogging) {
                if (file_exists($this->loggingPath)) {
                    $this->logFileHandle = fopen($this->loggingPath, 'a');
                } else {
                    if (!file_exists(dirname($this->loggingPath))) {
                        mkdir(dirname($this->loggingPath), 0777, true);
                    }
                    $this->logFileHandle = fopen($this->loggingPath, 'w');
                }
            }
        } catch (Exception $e) {
            throw new RuntimeException("Failed Opening Log File Handler with message: " . $e->getMessage());
        }
        if ($this->logFileHandle === false) {
            throw new RuntimeException("Failed to open log file for writing: {$this->loggingPath}");
        }
    }
}

function normalizePath($pathString) {
    if (empty($pathString) || $pathString === null) {
        return '';
    }

    $pathString = str_replace('\\', '/', $pathString);

    $pathString = preg_replace('/^~/', getenv('HOME'), $pathString);

    $pathString = preg_replace('/^\.\//', getcwd() . '/', $pathString);

    $pathString = preg_replace('/\.\.\//', '', $pathString);

    $pattern = '/\$\{(.*?)\}/';
    $pathString = preg_replace_callback($pattern, function ($matches) {
        $propertyName = $matches[1];
        $replacement = getenv($propertyName) ?: '';
        return $replacement;
    }, $pathString);

    if ($pathString[0] !== '/') {
        if (!($pathString[1] === ':' || $pathString[2] === '\\')) {
            $pathString = getcwd() . '/' . $pathString;
        }
    }

    return $pathString;
}

class SimpleLogger
{
    // Define the log levels
    const ERROR = 'error';
    const INFO = 'info';
    const DEBUG = 'debug';

    private $context;
    public function setLoggerContext($context)
    {
       $this->context = $context;
    }

    public function arrayToSpaceSeparatedString($array) {
        $result = '';
        if (!is_array($array)) {
            return $array;
        }
        foreach ($array as $key => $value) {
            $result .= "$key=$value, ";
        }
        $result = rtrim($result, ', ');
        return $result;
    }

    public function log($level, $message)
    {
        // Check if the log level is above or equal to the configured level
        $callerFunction = $this->getCallerFunction();

        if (PaymentHandlerConfig::getInstance()->getEnableLogging()) {
            $dateTime = new DateTime('now', new DateTimeZone('UTC'));

            // Format the timestamp in the desired format
            $formattedTimestamp = $dateTime->format('M d, Y h:i:s A');

            $formattedMessage = sprintf("%s in.PaymentHandler.%s\n%s: %s value=%s", $formattedTimestamp, $callerFunction, strtoupper($level), $this->arrayToSpaceSeparatedString($this->context), $message);

            // Log to console
            if ($level == self::ERROR) {
                $this->logToError($formattedMessage);
            } else {
                $this->logToConsole($formattedMessage);
            }
            // Log to file
            $this->logToFile($formattedMessage);
        }
    }

    protected function logToConsole($message)
    {
        // fwrite(STDERR, $message, PHP_EOL);
    }

    protected function logToFile($message)
    {
        fwrite(PaymentHandlerConfig::getInstance()->getLogFileHandle(), $message . PHP_EOL);
        fflush(PaymentHandlerConfig::getInstance()->getLogFileHandle());
    }

    protected function logToError($message)
    {
        // Log to standard error (stderr) instead of standard output (stdout)
        // fwrite(STDERR, $message . PHP_EOL);
    }
    // ... (same as before)

    protected function getCallerFunction()
    {
        $backtrace = debug_backtrace(DEBUG_BACKTRACE_PROVIDE_OBJECT, 4);

        if (isset($backtrace[3]['function'])) {
            return $backtrace[3]['function'];
        }

        return null;
    }


    public function error($message) {
        $this->log(self::ERROR, $message);
    }
    public function info($message) {
        $this->log(self::INFO, $message);
    }

    public function debug($message) {
        $this->log(self::DEBUG, $message);
    }
}


abstract class RequestMethod {
    const POST = 'POST';
    const GET = 'GET';
}

class ContentType {
    const X_WWW_FORM_URLENCODED = "application/x-www-form-urlencoded";
    const JSON = "application/json";
}
