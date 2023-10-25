# Juspay PHP Client Library #

-----------------------

The Juspay ExpressCheckout PHP SDK makes it easier for merchants to integrate the express-checkout APIs in their product. This SDK is distributed using `composer`. To add the SDK to your project, add the following code to your **composer.json**:


```
#!python

"require" : {
	"juspay/expresscheckout-php-sdk" : "1.0.4"
}

```

This package requires a `minimum-stability` of `stable`. Set the `minimum-stability` in your **composer.json** accordingly.

## Setting up the SDK for use. ##

By default SDK is initialised for Juspay production account.

**To setup PHP SDK for production account with default timeouts, use following code:**

```php
JuspayEnvironment::init()
->withApiKey("your_api_key")

```


**To setup PHP SDK for sandbox account with default timeouts, use following code:**

```php
JuspayEnvironment::init()
->withApiKey("yourApiKey")
->withBaseUrl(JuspayEnvironment::SANDBOX_BASE_URL)

```

**To setup PHP SDK for production account with custom timeouts, use following code:**

```php
JuspayEnvironment::init()
->withApiKey("yourApiKey")
->withConnectTimeout(connectTimeout)
->withReadTimeout(readTimeout);

```

**To setup PHP SDK for sandbox account with custom timeouts, use following code:**

```php
JuspayEnvironment::init()
->withApiKey("yourApiKey")
->withBaseUrl(JuspayEnvironment::SANDBOX_BASE_URL)
->withConnectTimeout(connectTimeout)
->withReadTimeout(readTimeout);
```

**To setup PHP SDK with custom CA Certificate, use following code:**

```php
JuspayEnvironment::init()
->withApiKey("yourApiKey")
->withBaseUrl(JuspayEnvironment::SANDBOX_BASE_URL)
->withCACertificatePath("file path to ca certificate");
```

## Using SDK ##
The input to all methods in SDK is an associative array and most of the methods will return the object of the corresponding class.
### Example: ###
**Adding a card to Juspay Locker:**

```php
$params = array ();
$params ['merchant_id'] = "merchantId";
$params ['customer_id'] = "customerId";
$params ['customer_email'] = "support@juspay.in";
$params ['card_number'] = "4111111111111111";
$params ['card_exp_year'] = "2018";
$params ['card_exp_month'] = "07";
$params ['name_on_card'] = "Juspay Technologies";
$params ['nickname'] = "ICICI VISA";
$card = Card::create ( $params );

```

**Getting order status using JWT**

Pass JuspayJWT in request option. JuspayJWT implements IJuspayJWT interface. IJuspayJWT has three methods consumePayload, preparePayload and Initialize (a factory method to initialize ISign and IEnc objects) along with three attributes array of keys, Sign of type ISign and Enc of type IEnc. JuspayJWT currently uses SignRSA5 which is a implementation of ISign interface and EncRSAOEAP which is a implementation of IEnc interface. Currently JuspayJWT class comes with the SDK. Implement IJuspayJWT to create custom JWT classes. JuspayJWT constructor accepts $keys and two kid as arguments.

**With RequestOptions**
```php
$params = array ();
$params ['order_id'] = $this->order->orderId;
$keys = [];
$privateKey = file_get_contents("./tests/privateKey.pem");
$publicKey = file_get_contents("./tests/publicKey.pem");
$order = Order::encryptedOrderStatus($params, new RequestOptions(new JuspayJWT("testJwe", $publicKey, $privateKey)));
```
**With JuspayEnvironment**
```php
$params = array ();
$params ['order_id'] = $this->order->orderId;
$keys = [];
$privateKey = file_get_contents("./tests/privateKey.pem");
$publicKey = file_get_contents("./tests/publicKey.pem");
JuspayEnvironment::init()->withJuspayJWT(new JuspayJWT("testJwe", $publicKey, $privateKey));
$order = Order::status($params, null);
```

**Error Handling**
```php
<?php
use Juspay\Exception\AuthenticationException;
use Juspay\Exception\APIConnectionException;
use Juspay\Exception\APIException;
use Juspay\Exception\InvalidRequestException;
use Juspay\Exception\JuspayException;
use Juspay\Model\Order;
try {
$params = array ();
$params ['order_id'] = "order id";
$order = Order::status ( $params );
}
catch (APIConnectionException ex)
{
// Handle API connection exception
}
catch (APIException ex)
{
// Handle API exception
}
catch (AuthenticationException ex)
{
// Handle Authentication exception
}
catch (InvalidRequestException ex)
{
// Handle invalid request exception
}
catch (JuspayException ex)
{
// All above exception extends juspay exception
// Default exception handler
}

```

**Sample Integration**
```php
<?php
use Juspay\JuspayEnvironment;
use Juspay\Model\Order;
use Juspay\Exception\JuspayException;
JuspayEnvironment::init ()
->withApiKey ("api key")
->withBaseUrl ("base url")
->withJuspay(new JuspayJWT($keys, "public key id");
try {

    // create order
    $orderId = uniqid ();
    $params = array ();
    $params ['order_id'] = $orderId;
    $params ['amount'] = 10000.0;
    $order = Order::create ( $params );
    $orderId = $order->orderId;

    // Get order
    $params = array ();
    $params ['order_id'] = $orderId;
    $order = Order::status ( $params );
    $status = $order->status; // verify status of the order ("NEW", "CHARGED"..)

    // update order
    $params = array ();
    $params ['amount'] = $order->amount + 100;
    $order = Order::update ( $params, $orderId );

    //Refund order
    $params = array ();
    $params ['order_id'] = $orderId;
    $params ['amount'] = 10;
    $params['unique_request_id'] = uniqid('php_sdk_test_');
    $order = Order::refund ( $params );
    $amountRefunded = $order->amountRefunded


}
catch (JuspayException $ex) {
    // Handle exception
}


## To Run Test

### PHP Version >=7.1 and <= 7.2
```shell
composer install --dev
./vendor/bin/phpunit tests -c ./phpunit-config-php7.xml
```
### PHP Version > 7.2
```shell
composer install --dev
./vendor/bin/phpunit tests -c ./phpunit-config-php8.xml
```
### PHP Version 5
```shell
./vendor/bin/phpunit tests -c ./phpunit-config-php7.xml
```
*Note:* Wallet test for authentication might fail due to OTP request limit
