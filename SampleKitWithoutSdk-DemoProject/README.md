# Sample Kit Using Web Servlets
This is a sample java kit using web-servlets.

## Setup
Place config.json file inside src/main/resources folder, ensure fields like API_KEY, MERCHANT_ID, PAYMENT_PAGE_CLIENT_ID & BASE_URL are populated.

### Rest endpoints
| Environment       | Endpoint                             |
|-------------------|--------------------------------------|
| Sandbox (default) | https://smartgatewayuat.hdfcbank.com |
| Production        | 	https://smartgateway.hdfcbank.com   |
configure this in BASE_URL

## Contents
### initiatePayment.jsp
This initiates payment to payment server it calls our /session api.

### handlePaymentResponse.jsp
Payment flow ends here, with status call, it's basically return_url configured by you in /session api or in dashboard. Please note that
it's POST method, hence you'll need a dispatcher for this.

### HandlePaymentResponse.java
This is just an example of dispatcher mentioned above in webservlet, it may vary dependending upon your use case.

### initiateRefund.jsp
It takes three params unique_request_id, order_id, amount and initiates refund at our server it calls /refunds api.

### initiatePaymentDataForm.html
This is just an example of checkout page and demo page for our /session api spec, please note that all the fields are kept readonly intentionally because we
recommend you to construct these params at your server. Send product-id from frontend and make a lookup at server side for amount.
Even if you change readonly field [initiatePayment.jsp](#initiatePayment.jsp) will not read those fields

### initiateRefundDataForm.html
This is just an example of checkout page and demo page for our /refunds api spec, please note that fields are editable and it asks order_id in request

### PaymentHandler class
This is where all the business logic is for calling our payments api

## Quick run this project using jetty?
### Setup
Inside SampleKitWithoutSdk-DemoProject folder
```bash
mvn clean install
mvn clean package
```
### run
```bash
mvn jetty:run
```
Goto:- http://localhost:8080/initiatePayment.jsp

### Test card credentials
card_number:- 4012001037141112

cvv:- 123

exp:- any future date