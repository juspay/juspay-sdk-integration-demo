<?php

namespace Juspay\Test;

use Juspay\Model\Customer;

class CustomerTest extends TestCase {
    public $customer;
    public function testCreate() {
        $customerId = uniqid ();
        $params = array ();
        $params ['first_name'] = "Juspay";
        $params ['last_name'] = "Technologies";
        $params ['mobile_country_code'] = "91";
        $params ['mobile_number'] = "9988776655";
        $params ['email_address'] = "support@juspay.in";
        $params ['object_reference_id'] = $customerId; 
        $customer = Customer::create ( $params );
        $this->assertTrue( $customer != null );
        $this->assertTrue( $customer->id != null );
        $this->assertTrue( $customer->firstName != null );
        $this->assertTrue( $customer->lastName != null );
        $this->assertTrue( $customer->mobileCountryCode != null );
        $this->assertTrue( $customer->mobileNumber != null );
        $this->assertTrue( $customer->emailAddress != null );
        $this->assertTrue( $customer->objectReferenceId != null );
        $this->customer = $customer;
    }
    public function testUpdate() {
        $this->testCreate ();
        $params = array ();
        $params ['first_name'] = "Juspay1";
        $params ['last_name'] = "Technologies1";
        $params ['mobile_country_code'] = "92";
        $params ['mobile_number'] = "9988776656";
        $params ['email_address'] = "support1@juspay.in";
        $customer = Customer::update ( $this->customer->id, $params );
        $this->assertTrue ( $customer != null );
        $this->assertTrue ( $customer->id != null );
        $this->assertTrue ( $customer->firstName == $params ['first_name'] );
        $this->assertTrue ( $customer->lastName == $params ['last_name'] );
        $this->assertTrue ( $customer->mobileCountryCode == $params ['mobile_country_code'] );
        $this->assertTrue ( $customer->mobileNumber == $params ['mobile_number'] );
        $this->assertTrue ( $customer->emailAddress == $params ['email_address'] );
    }
    // public function testList() {
    //     $this->testCreate ();
    //     $customers = Customer::listAll ( null );
    //     $this->assertTrue ( $customers != null );
    //     $this->assertTrue ( count ( $customers ) > 0 );
    // }
    public function testGet() {
        $this->testCreate ();
        $customer = Customer::get ( $this->customer->id );
        $this->assertTrue ( $customer != null );
    }
}
require_once __DIR__ . '/TestEnvironment.php';
