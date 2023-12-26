curl --location --request POST 'https://api.juspay.in/session' \
    --header 'x-merchantid: yourMerchantId' \
    --header 'Authorization: Basic base64encodedkey==' \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "amount":"10.00",
    "order_id":"yourUniqueOrderId",
    "customer_id":"yourUniqueCustId",
    "customer_phone":"9876543210",
    "customer_email":"dummyemail@gmail.com",
    "payment_page_client_id":"picasso",
    "return_url": "https://shop.merchant.com",
    "action":"paymentPage",
    "options.create_mandate":"OPTIONAL/REQUIRED",
    "mandate.max_amount":"1000.00",
    "metadata.split_settlement_details":"{\"marketplace\":{\"amount\":1},\"mdr_borne_by\":\"ALL\",\"vendor\":{\"split\":[{\"amount\":1,\"merchant_commission\":0,\"sub_mid\":\"Vendor1\"},{\"amount\":1,\"merchant_commission\":0,\"sub_mid\":\"Vendor2\"}]}}\"
}"