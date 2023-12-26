curl --location --request POST 'https://sandbox.juspay.in/session' \
--header 'Authorization: Basic ODM5QkE0OTRCN000askjdlaskj' \
--header 'x-merchantid: mid' \
--header 'Content-Type: application/json' \
--data-raw '{
    "amount":"1.00",
    "order_id":"mny_aj_12",
    "customer_id":"cust_id",
    "customer_phone":"9876500000",
    "customer_email":"dummyemail@gmail.com",
    "payment_page_client_id":"mid",
    "return_url": "https://mid.in",
    "order_type" : "TPV_PAYMENT",
  "options.create_mandate" : "REQUIRED",
  "metadata.bank_account_details" : "[{\"bank_account_number\":\"83748239234000\",\"bank_ifsc\":\"AABD0000011\", \"bank_beneficiary_name\" : \"Abc\"}]",
    "action":"paymentPage",
    "mandate.max_amount":"1000.00"
}'