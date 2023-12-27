curl --location 'https://sandbox.juspay.in/payout/merchant/v1/orders/:orderId?expand=fulfillment%2Cpayment%2Crefund' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)'
