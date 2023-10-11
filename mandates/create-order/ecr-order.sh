curl --location --request POST 'https://sandbox.juspay.in/session' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic MkNFQkU4QjYyQkQ0MDkwOEMzNzNGQUNBRDRGNjA1Og==' \
--header 'version: 2023-08-01' \
--data-raw '{
  "order_id": "order1697020098a",
  "amount": "1",
  "customer_id": "cth_qYcqE4hVnwL2Esnk",
  "customer_email": "juspay.jus@gmail.com",
  "customer_phone": "6369288490",
  "payment_page_client_id": "fortum",
  "first_name":"Sim",
  "action": "paymentPage",
  "return_url": "https://juspay.in/",
  "gateway_id": "12",
  "order_type" : "TPV_PAYMENT",
  "options.create_mandate" : "REQUIRED",
  "metadata.bank_account_details" : "[{\"bank_account_number\":\"83748239234872\",\"bank_ifsc\":\"AABC0876543\", \"juspay_bank_code\" : \"500007\", \"bank_beneficiary_name\" : \"Abc\"}]",
  "mandate.max_amount" : "3"
}