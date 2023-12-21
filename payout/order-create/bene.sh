curl --location --request POST 'https://smartgateway.hdfcbank.com/payout/merchant/v1/orders/' \
--header 'Authorization: ***************************' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant-id>' \
--data-raw '{
    "orderId":"65YmmR7tWPxssB55",
    "fulfillments": [
        {
            "preferredMethodList": ["CFGEN_IMPS"],
            "amount": 11,
            "beneficiaryDetails": {
                "details": {
                    "name": "Arun Kumar",
                    "id": "pa_dry_run00"
                },
                "type": "BENE_ID"
            }
        }
    ],
    "amount": 11,
    "customerId": "arun1",
    "customerPhone": "9999099999",
    "customerEmail": "shubham@gmail.com",
    "type": "FULFILL_ONLY"
}'