curl --location --request POST 'https://sandbox.juspay.in/payout/merchant/v1/orders' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data-raw '{
    "orderId": "ONaajHngrONssVSu",
    "fulfillments": [
       {
           "preferredMethodList": [
               "PAGSEGURO_WALLET"
           ],
           "amount": 1,
           "beneficiaryDetails": {
               "details": {
                   "walletIdentifier" : "a1f4102e-a446-4a57-bcce-6fa48899c1d2",
                   "brand" : "PIX_KEY",
                   "payeeAdditionalDetails" : {
                       "documents" : [
                           {
                               "docId" : "853.513.468-93",
                               "docType" : "CNPJ"
                           }
                       ],
                       "country" : "BRA",
                       "name" : "Tushar"
                   }                
               },
               "type": "WALLET"
           },
           "additionalInfo" : {
               "transactionType" : "B2C"
           },
           "fulfillmentCurrency" : "BRL"
       }
   ],
   "amount": 1,
   "customerId": "dsgsdgfsdgfsg",
   "customerPhone": "11987654321",
   "customerEmail": "name@gmail.com",
   "type": "FULFILL_ONLY"
}'
