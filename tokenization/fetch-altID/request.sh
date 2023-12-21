curl --request POST \
     --url 'https://smartgateway.hdfcbank.com/get/altId?Content-type=application%2Fjson' \
     --header 'Authorization: Basic XXXXAPIKEYXXXXX' \
     --header 'accept: application/json' \
     --header 'authorization: Basic NkU3RDE3NzA5REU0RkQ5QkY2QUYwMzlEQ0E1QTk5Og==' \
     --header 'content-type: application/json' \
     --header 'x-merchantId: JuspayMID' \
     --data 'orderData={         "amount" : "1",         "currency": "INR",         "authRefNumber": "20580201098"     }' \
     --data 'correlationId=Unique reference ID for the request'