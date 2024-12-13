curl --request GET \ 
--url https://api.juspay.in/payout/client/v1/linkwallet \
--header 'x-merchantid: <merchant id>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "client_auth_token" :"9b74d1f4cb347ac964f5587a2e01bf100016",
    "merchantReturnUrl" : "https://www.abc.com/",
    "customerId" : "juspaycustomer1",
    "customerPhone" : "9475839573",
    "customerEmail" : "tusharjuspay1@example1.com",
    "beneficiaryID" : "loginflowid1"
}'
