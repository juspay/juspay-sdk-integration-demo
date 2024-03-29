curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/session' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--header 'x-merchantid: your_merchant_id' \
--header 'Content-Type: application/json' \
--data-raw '{
    "order_id": "testing-order-one",
    "amount": "2000.0",
    "currency" : "INR",
    "customer_id": "testing-customer-one",
    "customer_email": "test@mail.com",
    "customer_phone": "9876543210",
    "payment_page_client_id": "your_client_id",
    "action": "paymentPage",
    "return_url": "https://shop.merchant.com",
    "description": "Complete your payment",
    "first_name": "John",
    "last_name": "wick",
    "payment_filter" : {
        "allowDefaultOptions": false,
        "options": [
          {
             "paymentMethodType": "NB",
             "enable": true
          },
          {
             "paymentMethodType": "UPI",
             "enable": true
          },
          {
             "paymentMethodType": "CARD",
             "enable": true
          },
          {
             "paymentMethodType": "WALLET",
             "enable" : true
          }
       ]
     },
"metadata.expiryInMins" : "15",
"metadata.JUSPAY:gatewayReferenceId": "payu_test",
"source_object" : "PAYMENT_LINK",
"udf1": "udf1-dummy",
"udf2": "udf2-dummy",
"udf3": "udf3-dummy",
"udf4": "udf4-dummy",
"udf6": "udf6-dummy",
"udf5": "udf5-dummy",
"udf7": "udf7-dummy",
"udf8": "udf8-dummy",
"udf9": "udf9-dummy",
"udf10": "udf10-dummy",
"send_mail": true,
"send_sms" : true}'