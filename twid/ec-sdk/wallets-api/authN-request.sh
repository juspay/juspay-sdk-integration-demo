curl --location 'https://sandbox.juspay.in/customers/{customer_id}/wallets' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic OTNBQTlFNzdCM********==' \
--data-urlencode 'gateway=TWID_V2' \
--data-urlencode 'command=authenticate' \
--data-urlencode 'gateway_reference_id=testmode' \
--data-urlencode 'mobile_number=708****413' \