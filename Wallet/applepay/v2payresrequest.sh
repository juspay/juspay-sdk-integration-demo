curl --location 'https://sandbox.juspay.in/v2/pay/response/merchantId/eulk55C8xbgvVh3rSLD4' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic M***********=' \
--data-urlencode 'tokenPayload={"token":{"paymentData":{"data":"X********Y","header":{"publicKeyHash":"x******y","ephemeralPublicKey":"y******x","transactionId":"afcb290d2b217f413f2e26a17adef562801a03c923daf2214422c385adefa07"},"version":"EC_v1"},"paymentMethod":{"displayName":"Visa 0326","network":"Visa","type":"debit"},"transactionIdentifier":"afcb290d2b217f413f2e26a17adef562801a03c923daf2214422c385adefa07"}}'
