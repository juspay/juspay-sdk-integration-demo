curl POST 'https://api.juspay.in/mandates/:mandate_id' \
    -H 'Authorization: Basic <Base-64 Key>' \
    -H 'x-routing-id: customer_1122'\
    -H 'x-merchantid: merchant' \
	-d command=”revoke”
