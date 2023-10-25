<?php
    // namespace Juspay\Test;
    // use Juspay\Test\OrderTest;
    require_once __DIR__ . "/tests/OrderTest.php";
    $OrderTest = new OrderTest(); 
    $OrderTest->testCreate();
    $OrderTest->testUpdate();
    $OrderTest->testEncryptedOrderStatus();
    
?>