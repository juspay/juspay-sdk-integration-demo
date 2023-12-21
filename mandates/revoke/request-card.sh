curl POST 'https://smartgateway.hdfcbank.com/mandates/:mandate_id' \
    -H 'Authorization: Basic <Base-64 Key>' \
    -H 'x-merchantid: merchant' \
	-d command=”revoke”
