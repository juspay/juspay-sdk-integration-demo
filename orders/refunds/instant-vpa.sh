curl -X POST \
 https://smartgateway.hdfcbank.com/refunds \
 -u your_api_key: \
-H 'Content-Type: application/x-www-form-urlencoded' \
 -d “unique_request_id”:”rfd_1234” \
-d “amount”:”98.20” \
-d “order_id”:”ord_123” \ 
-d “refund_type”:”INSTANT” \
-d “Beneficiary_details”: {
    "details": {
        "name": "Taral Shah",
        "vpa": "xyz@upi"
        },
    "type": "UPI_ID"
    }