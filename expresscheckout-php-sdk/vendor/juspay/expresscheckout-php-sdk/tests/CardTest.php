<?php

namespace Juspay\Test;

use Juspay\Model\Card;

class CardTest extends TestCase {
    // private $customerTest;

    // private $customerId;
    // private $card;
    // public function testCreate() {
    //     if ($this->customerTest == null) {
    //         $this->customerTest = new CustomerTest();
    //         $this->customerTest->testCreate();
    //         $this->customerId = $this->customerTest->customer->id;
    //     }
    //     $params = array ();
    //     $params ['merchant_id'] = TestEnvironment::$merchantId;
    //     $params ['customer_id'] = $this->customerId;
    //     $params ['customer_email'] = "support@juspay.in";
    //     $params ['card_number'] = "4111111111111111";
    //     $params ['card_exp_year'] = "2018";
    //     $params ['card_exp_month'] = "07";
    //     $params ['name_on_card'] = "Juspay Technologies";
    //     $params ['nickname'] = "ICICI VISA";
    //     $card = Card::create ( $params );
    //     assert ( $card != null );
    //     assert ( $card->cardToken != null );
    //     assert ( $card->cardReference != null );
    //     assert ( $card->cardFingerprint != null );
    //     $this->card = $card;
    // }
    // public function testList() {
    //     $this->testCreate ();
    //     $params = array (
    //             "customer_id" => $this->customerId,
    //     );
    //     $cards = Card::listAll ( $params );
    //     assert ( $cards != null );
    //     assert ( count ( $cards ) == 1 );
    // }
    // public function testDelete() {
    //     $this->testCreate ();
    //     $params = array (
    //             "card_token" => $this->card->cardToken 
    //     );
    //     $deleted = Card::delete ( $params );
    //     assert ( $deleted == true );
    // }
}
require_once __DIR__ . '/TestEnvironment.php';
