<?php

namespace Juspay\Test;

use Juspay\Model\PaymentMethod;

class PaymentMethodTest extends TestCase {
    public function testList() {
        $paymentMethods = PaymentMethod::listAll( TestEnvironment::$merchantId );
        $this->assertTrue( $paymentMethods != null );
    }
}
require_once __DIR__ . '/TestEnvironment.php';