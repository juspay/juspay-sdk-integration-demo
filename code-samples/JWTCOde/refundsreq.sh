curl --location -g --request POST 'https://smartgatewayuat.hdfcbank.com/v4/orders/{order_id}/refunds' \
--header 'x-merchantid: testhdfc1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "iv": "kdshfdjksfQQQQBBKFKJJFKKFJKJksadjfhjsdafjhd",
  "encryptedKey": "ksdfdksf123343djfdjfjdsf",
  "header": "eyJhbGciOiJSU0EtT0FFUC0yNjdfdsjhfsdfsdY5MjRiMGY4MDc4MzI4MzQwOGE1NDJmIn0",
  "encryptedPayload": "ksdfdshk9998jsdsdhfhfhjsdhf",
  "tag": "9YD4q-AaM4xYGMHz5dlarQ"
}'
