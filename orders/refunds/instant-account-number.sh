curl -X POST \
 https://api.juspay.in/refunds \
 -u your_api_key: \
-H 'Content-Type: application/x-www-form-urlencoded' \
 -d “unique_request_id”:”rfd_1234” \
-d “amount”:”98.20” \
-d “order_id”:”ord_123” \ 
-d “refund_type”:”INSTANT” \
-d “Beneficiary_details”: {
		"details": {
        "name": "Taral Shah",
        "account": "026687138917581",
        "ifsc" : "YESB0000262"
   			}, 
    "type": "ACCOUNT_IFSC"
    }
