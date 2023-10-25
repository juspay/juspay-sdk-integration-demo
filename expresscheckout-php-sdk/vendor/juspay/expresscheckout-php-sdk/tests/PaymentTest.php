<?php

namespace Juspay\Test;

use Juspay\Model\Payment;

class PaymentTest extends TestCase {
    public function testCreate() {
        $orderTest = new OrderTest ();
        $orderTest->testCreate ();
        $params = array ();
        $params ['order_id'] = $orderTest->order->orderId;
        $params ['merchant_id'] = TestEnvironment::$merchantId;
        $params ['payment_method_type'] = "CARD";
        $params ['payment_method'] = "MASTERCARD";
        $params ['redirect_after_payment'] = true;
        $params ['card_number'] = "5243681100075285";
        $params ['card_exp_month'] = "10";
        $params ['card_exp_year'] = "20";
        $params ['card_security_code'] = "111";
        $params ['save_to_locker'] = false;
        $payment = Payment::create ( $params );
        assert ( $payment != null );
        assert ( $payment->orderId == $orderTest->order->orderId );
        assert ( $payment->status == "PENDING_VBV" );
    }
}
require_once __DIR__ . '/TestEnvironment.php';