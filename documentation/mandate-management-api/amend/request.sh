curl --location --request PATCH 'https://api-test.lotuspay.com/api/mandates/amend?mandate_id=MD0086WWA8U5CH' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic c2tfdGVzdF82MXFIUURuYTgzMWNOTm9vb29uRzFlQWlEOg==' \
--data '{
    "final_collection_date": "2032-11-12"
}'