curl --location --request POST 'https://sandbox.juspay.in/v4/card/get' \
 --header 'Authorization: Basic <BASE 64 encoded version of API key>' \
 --header 'Content-Type: application/json' \
 --data-raw '{"card_reference":"card_reference_value_goes_here","customer_id": "customer_value_goes_here"}'
