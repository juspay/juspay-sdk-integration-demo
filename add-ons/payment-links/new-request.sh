curl --location 'https://sandbox.juspay.in/session' \
--header 'origin: https://sandbox.juspay.in' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic *********************API_KEY' \
--data-raw '{"currency": "INR",
   "mobile_country_code": "+91",
   "mandate.revokable_by_customer": true,
   "mandate_frequency": "ASPRESENTED",
   "options.create_mandate": "REQUIRED",
   "mandate.block_funds": false,
   "mandate_start_date": "2023-12-28T12:49:36",
   "payment_page_client_id": "picasso",
   "upiCheckBox": [
       "UPI"
   ],
   "netbankingCheckBox": null,
   "cardsCheckBox": [
       "Cards"
   ],
   "walletCheckBox": [
       "Wallets"
   ],
   "amount": 100,
   "customer_email": "asdf@gmail.com",
   "customer_phone": "8987654567",
   "shouldSendSMS": true,
   "shouldSendWhatsapp": true,
   "shouldSendMail": true,
   "description": "This is Payment Description.",
   "mandate_max_amount": "1000",
   "mandate.end_date": "1733011200",
   "customer_id": "customer_id",
   "gateway_id": "12",
   "order_id": "order_a_b_id_dummy_1",
   "return_url": "https://juspay.in/",
   "udf1": "udf1-dummy",
   "udf2": "udf2-dummy",
   "udf3": "udf3-dummy",
   "udf4": "udf4-dummy",
   "udf6": "udf6-dummy",
   "udf5": "udf5-dummy",
   "udf7": "udf7-dummy",
   "udf8": "udf8-dummy",
   "udf10": "udf10-dummy",
   "udf9": "udf9-dummy",
   "mandate.frequency": "ASPRESENTED",
   "options.create_mandate": "REQUIRED",
   "mandate.start_date": "1703768016.296",
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
   "metadata.JUSPAY:gateway_reference_id": "payu_test",
   "metadata.expiryInMins": "3397",
   "merchant_id": "chetan_test"
}
'
