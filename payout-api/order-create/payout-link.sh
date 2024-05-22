curl --location 'https://sandbox.juspay.in/payout/merchant/v1/orders' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data-raw '{
    "orderId": "1716370593",
    "fulfillments": [
        {
            "amount": 9.00,
            "beneficiaryDetails": {
                "details": {
                    "name": "Test Name",
                    "mobileNo" : "8408099821"
                },
                "type": "PAYOUT_LINK"
            }

        }
    ],
    "amount": 9.00,
    "customerId": "cth_aC7pPDuatTkYsXHr",
    "customerPhone": "8408099821",
    "customerEmail": "test@gmail.com",
    "type": "FULFILL_ONLY"
}'
