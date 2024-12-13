curl --location 'https://api.juspay.in/orders' \
--header 'Authorization: Basic <api_key>' \
--header 'Accept: */*' \
--header 'Content-Type: application/json' \
--data-raw '{"order_id":"ord_1734075085","amount":"1","currency":"INR","customer_id":"cth_rg41utz8P5abMBxB","customer_email":"xxx@gmail.com","customer_phone":"9876543210","product_id":"JPP20241212163917","return_url":"https://juspay.in/","description":"Description","gateway_id":"505","mandate_max_amount":"50","options.create_mandate":"REQUIRED","mandate.end_date":"1734244025","mandate.frequency":"ONETIME","metadata.ICICI_UPI:gateway_reference_id":"icici_upi_test"}'
