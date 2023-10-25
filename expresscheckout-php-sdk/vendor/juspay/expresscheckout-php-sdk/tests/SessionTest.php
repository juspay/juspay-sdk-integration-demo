<?php

namespace Juspay\Test;

use Juspay\Exception\JuspayException;
use Juspay\JuspayEnvironment;
use Juspay\Model\JuspayJWT;
use Juspay\Model\Session;
use Juspay\RequestOptions;


class SessionTest extends TestCase {
    public $session;
    public function testCreate() {

        $orderTest = new OrderTest();
        $orderTest->testCreate();
        $orderId = $orderTest->order->orderId;
        $customerTest = new CustomerTest();
        $customerTest->testCreate();
        $customerId = $customerTest->customer->objectReferenceId;
        $params = json_decode("{\n\"amount\":\"10.00\",\n\"order_id\":\"$orderId\",\n\"customer_id\":\"$customerId\",\n\"payment_page_client_id\":\"azharamin\",\n\"action\":\"paymentPage\",\n\"return_url\": \"https://google.com\"\n}", true);
        $session = Session::create ( $params );
        $this->assertTrue($session->status == "NEW");
        $this->assertTrue($session->id != null);
        $this->assertTrue($session->orderId != null);
        $this->assertTrue($session->paymentLinks != null);
        $this->assertTrue($session->sdkPayload != null);
        $this->session = $session;
    }

    public function testEncryptedCreateOrderSession() {
        $orderTest = new OrderTest();
        $orderTest->testCreate();
        $orderId = $orderTest->order->orderId;
        $customerTest = new CustomerTest();
        $customerTest->testCreate();
        $customerId = $customerTest->customer->objectReferenceId;
        $merchantId = TestEnvironment::$merchantId;
        $params = json_decode("{\n\"amount\":\"10.00\",\n\"order_id\":\"$orderId\",\n\"customer_id\":\"$customerId\",\n\"payment_page_client_id\":\"$merchantId\",\n\"action\":\"paymentPage\",\n\"return_url\": \"https://google.com\"\n}", true);
        $privateKey = file_get_contents("./tests/privateKey.pem");
        $publicKey = file_get_contents("./tests/publicKey.pem");
        $session = Session::create($params, new RequestOptions(new JuspayJWT("key_26b1a82e16cf4c6e850325c3d98368cb", $publicKey, $privateKey)));
        $this->assertTrue($session->status == "NEW");
        $this->assertTrue($session->id != null);
        $this->assertTrue($session->orderId != null);
        $this->assertTrue($session->paymentLinks != null);
        $this->assertTrue($session->sdkPayload != null);
        $this->session = $session;
    }
    public function testEncryptedCreateOrderSessionGloabl() {
        $orderTest = new OrderTest();
        $orderTest->testCreate();
        $orderId = $orderTest->order->orderId;
        $customerTest = new CustomerTest();
        $customerTest->testCreate();
        $customerId = $customerTest->customer->objectReferenceId;
        $merchantId = TestEnvironment::$merchantId;
        $params = json_decode("{\n\"amount\":\"10.00\",\n\"order_id\":\"$orderId\",\n\"customer_id\":\"$customerId\",\n\"payment_page_client_id\":\"$merchantId\",\n\"action\":\"paymentPage\",\n\"return_url\": \"https://google.com\"\n}", true);
        $privateKey = file_get_contents("./tests/privateKey.pem");
        $publicKey = file_get_contents("./tests/publicKey.pem");
        JuspayEnvironment::init()->withJuspayJWT(new JuspayJWT("key_26b1a82e16cf4c6e850325c3d98368cb", $publicKey, $privateKey));
        try {
            $session = Session::create($params, new RequestOptions(new JuspayJWT("key_26b1a82e16cf4c6e850325c3d98368cb", $publicKey, $privateKey)));
            $this->assertTrue($session->status == "NEW");
            $this->assertTrue($session->id != null);
            $this->assertTrue($session->orderId != null);
            $this->assertTrue($session->paymentLinks != null);
            $this->assertTrue($session->sdkPayload != null);
            $this->session = $session;
        }   catch ( JuspayException $e ) {
            JuspayEnvironment::init()->withJuspayJWT(null);
            $this->assertTrue ( "invalid.order.not_successful" == $e->getErrorCode () );
        }
        JuspayEnvironment::init()->withJuspayJWT(null);
    }
}
require_once __DIR__ . '/TestEnvironment.php';
