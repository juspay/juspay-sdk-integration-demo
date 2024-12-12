curl --location --request PATCH 'https://api-test.lotuspay.com/api/mandates/amend?umrn=YESB7031077880493840' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic c2tfdGVzdF82MXFIUURuYTgzMWNOTm9vb29uRzFlQWlEOg==' \
--data '{
    "frequency": "ADHO",
    "maximum_amount": "5.00"
}'