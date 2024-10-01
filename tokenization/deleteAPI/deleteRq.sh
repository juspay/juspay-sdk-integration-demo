curl --location --request POST 'https://sandbox.juspay.in/v4/card/delete' \
--header 'Authorization: Basic <Base 64 encoded of API key>' \
--header 'Content-Type: application/json' \
--data-raw '{"card_reference":"card_reference_values_goes_here","customer_id": "customer_id_value_goes_here"}'
