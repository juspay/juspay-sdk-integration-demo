# Sample Kit Using Web Servlets
This is a sample php kit using php development web server.

## Setup
- Place config.json file inside resources folder, ensure fields like API_KEY, MERCHANT_ID, PAYMENT_PAGE_CLIENT_ID & BASE_URL are populated.
- Incase of SSL Certificate Error add cacert with PaymentHandlerConfig's method `withCacert("path to cacertificate")` or add it to php.ini (curl.cainfo)

### Rest endpoints
| Environment       | Endpoint                             |
|-------------------|--------------------------------------|
| Sandbox (default) | https://smartgatewayuat.hdfcbank.com |
| Production        | 	https://smartgateway.hdfcbank.com  |

configure this in BASE_URL

## Contents
### initiatePayment.php
This initiates payment to payment server it calls /session api.

### handlePaymentResponse.php
Payment flow ends here, with hmac verification and order status call. This is the return url specified in /session api call or can be configured through dasboard.


### initiateRefund.php
It takes three params unique_request_id, order_id, amount and initiates refund to server, it calls /refunds api.

### initiatePaymentDataForm.php
This is an example of checkout page and demo page for /session api spec, please note that all the fields are kept readonly intentionally because we
recommend you to construct these params at server side. Send product-id from frontend and make a lookup at server side for amount.

### initiateRefundDataForm.html
This is just an example of checkout page and demo page for /refunds api spec

### PaymentHandler class
This is where all the business logic is for calling payments api exists

<!-- block:start:run-server -->
### run
```bash
php -S localhost:5000
```
Goto:- http://localhost:5000/initiatePaymentDataForm.php
<!-- block:end:run-server -->

[:warning:]
<mark>This sample project uses php development web server don't use it in production<mark>