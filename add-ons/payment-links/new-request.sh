curl --location 'https://sandbox.juspay.in/session' \
--header 'origin: https://sandbox.juspay.in' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic *********************API_KEY' \
--data-raw '{
   "mobile_country_code": "+91",
   "payment_page_client_id": "picasso",
   "amount": 100,
   "currency": "INR",
   "action": "paymentPage", 
   "customer_email": "asdf@gmail.com",
   "customer_phone": "8888899999",
   "first_name": "John",
   "last_name" : "Doe",
   "description": "This is Payment Description.",
   "customer_id": "customer_id",
   "order_id": "order_dummy_1",
   "return_url": "https://juspay.in/",
   "mandate.revokable_by_customer": true,
   "mandate.block_funds": false,
   "mandate_max_amount": "1000",
   "mandate.start_date": "1703768016",
   "mandate.end_date": "1733011200",
   "mandate.frequency": "ASPRESENTED",
   "options.create_mandate": "REQUIRED",
   "send_mail": true,
   "send_sms": false,
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
   "payment_filter": {
       "allowDefaultOptions": false,
       "options": [
           {
               "paymentMethodType": "UPI",
               "enable": true
           },
           {
               "paymentMethodType": "WALLETS",
               "enable": true
           },
           {
               "paymentMethodType": "CARD",
               "enable": true
           },
           {
               "paymentMethodType": "NB",
               "enable": false
           }
       ],
       "emiOptions": {}
   },
   "gateway_id": "12",
   "metadata.JUSPAY:gateway_reference_id": "payu_test",
   "metadata.expiryInMins": "3397"
  }
'