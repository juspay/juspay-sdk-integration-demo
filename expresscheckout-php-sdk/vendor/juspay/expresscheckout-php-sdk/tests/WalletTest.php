<?php

namespace Juspay\Test;

use Juspay\Model\Customer;
use Juspay\Model\Wallet;

class WalletTest extends TestCase {
    private $customerTest;
    private $wallet;
    public function testCreate() {
        if ($this->customerTest == null) {
            $this->customerTest = new CustomerTest ();
            $this->customerTest->testCreate ();
        }
        $this->wallet = Wallet::create ( $this->customerTest->customer->objectReferenceId, 'MOBIKWIK' );
        assert ( $this->wallet != null );
    }
    public function testList() {
        $this->testCreate ();
        $wallets = Wallet::listAll ( $this->customerTest->customer->objectReferenceId );
        assert ( $wallets != null );
    }
    public function testRefresh() {
        $this->testCreate ();
        $wallets = Wallet::refresh ( $this->customerTest->customer->objectReferenceId );
        assert ( $wallets != null );
    }
    public function testRefreshByWalletId() {
        $this->testCreate ();
        $this->wallet = Wallet::refreshByWalletId ( $this->wallet->id );
        assert ( $this->wallet != null );
    }
    public function testCreateAndAuthenticate() {
        if ($this->customerTest == null) {
            $this->customerTest = new CustomerTest ();
            $this->customerTest->testCreate ();
        }
        $this->wallet = Wallet::createAndAuthenticate ( $this->customerTest->customer->objectReferenceId, "MOBIKWIK" );
        assert ( $this->wallet != null );
    }
    public function testAuthenticate() {
        $this->testCreate ();
        $this->wallet = Wallet::authenticate ( $this->wallet->id );
        assert ( $this->wallet != null );
    }
}
require_once __DIR__ . '/TestEnvironment.php';