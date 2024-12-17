curl --request POST \ 
--url https://api.juspay.io/payout/merchant/v1/linkwallet \
--header 'x-merchantid: <merchant id>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "merchantReturnUrl" : "https://www.abc.com/",
    "customerId" : "juspaycustomer1",
    "customerPhone" : "9475839573",
    "customerEmail" : "tusharjuspay1@example1.com",
    "beneficiaryID" : "loginflowid1"
}'
