curl --location 'https://smartgatewayuat.hdfcbank.com/mandates/<mandate_id>' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchant-id: mandate_juspay' \
--header 'Authorization: Basic <api key in base64 format>' \
--data-urlencode 'command=revoke'
