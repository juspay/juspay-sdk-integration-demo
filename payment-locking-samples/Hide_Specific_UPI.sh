url --location --request POST 'https://api.juspay.in/session' \
    --header 'x-merchantid: yourMerchantId' \
    --header 'Authorization: Basic base64encodedkey==' \
    --header '{
   "order_id": "R8205947560",
   "first_name": "John",
   "last_name": "Wick",
   "mobile_number": "9592329220",
   "email_address": "test007@gmail.com",
   "customer_id": "9592329220",
   "timestamp": "1611559686153",
   "merchant_id": "abcd",
   "amount": "1.00",
   "currency": "INR",
   "payment_filter": {
       "allowDefaultOptions": true,
       "options": [{
               "paymentMethodType": "UPI",
               "enable": true,
               "upiFilters": [{
                       "upiType": "COLLECT",
               "enable": false,     
                       "upiMethods": ["@ybl", "@okhdfcbank"]
                   },
                   {
                       "upiType": "INTENT",
                       "enable": false,
                       "upiMethods": ["PHONEPE", "GPAY", "PAYTM"]
                   }]
               }
           ]
       }
}'