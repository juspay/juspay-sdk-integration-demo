curl --location --request POST '<merchant-url>' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic <Base64_encoded_username:password>' \
--data-raw '{
    "order_id": "{{timestamp}}",
    "amount": "10.0",
    "return_url": "https://merchantreturlurl.in",
    "first_name": "A",
    "last_name": "B", 
    "metadata.webhook_url": "https://merchantdynamicwebhookurl.in"
}'
