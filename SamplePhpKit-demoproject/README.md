# Sample Kit Using Web Servlets
This is a sample php kit using php web server.

## Setup
- Place config.json file inside resources folder, ensure fields like API_KEY, MERCHANT_ID, PAYMENT_PAGE_CLIENT_ID & BASE_URL are populated.
- Incase of SSL Certificate Error add cacert with PaymentHandlerConfig's method `withCacert("path to cacertificate")` or add it to php.ini (curl.cainfo)

### Rest endpoints
| Environment       | Endpoint                             |
|-------------------|--------------------------------------|
| Sandbox (default) | https://smartgatewayuat.hdfcbank.com |
| Production        | 	https://smartgateway.hdfcbank.com   |
configure this in BASE_URL

## Contents
### initiatePayment.php
This initiates payment to payment server it calls our /session api.

### handlePaymentResponse.php
Payment flow ends here, with status call, it's basically return_url configured by you in /session api or in dashboard. Please note that
it's POST method, hence you'll need a dispatcher for this.


### initiateRefund.php
It takes three params unique_request_id, order_id, amount and initiates refund at our server it calls /refunds api.

### initiatePaymentDataForm.php
This is just an example of checkout page and demo page for our /session api spec, please note that all the fields are kept readonly intentionally because we
recommend you to construct these params at your server. Send product-id from frontend and make a lookup at server side for amount.
Even if you change readonly field [initiatePaymentDataForm.php](#initiatePayment.php) will not read those fields

### initiateRefundDataForm.html
This is just an example of checkout page and demo page for our /refunds api spec, please note that fields are editable and it asks order_id in request

### PaymentHandler class
This is where all the business logic is for calling our payments api


### run
```bash
php -S localhost:5000
```
Goto:- http://localhost:5000/initiatePaymentDataForm.php

[:warning:]
<mark>This sample project uses php development web server<mark>