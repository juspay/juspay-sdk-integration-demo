curl --request POST \
     --url https://smartgateway.hdfcbank.com/generateToken \
     --header 'Authorization: Basic XXXXAPIKEYXXXXX' \
     --header 'accept: application/json' \
     --header 'authorization: Basic NxxxxxxxxxxxxxxxxxxxxkY2QUYwMzlEQ0E1QTk5Og==' \
     --header 'content-type: application/json' \
     --header 'x-merchantId: JuspayMID' \
     --data 'orderData={         "consentId" : "ae3877f948bd4c95",         "customerId" : "abcd6831",         "amount" : "1",         "currency": "INR"     }' \
     --data 'auditData={         "authRefNo" : "4c95b016def8806314bf"     }' \
     --data service=NETWORK_TOKEN
