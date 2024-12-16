curl --location --request GET 'https://sandbox.juspay.io/payout/merchant/v1/orders/:orderId?expand=fulfillment' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)'
