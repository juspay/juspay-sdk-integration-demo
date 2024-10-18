curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/v4/order-status' \
--header 'x-merchantid: testhdfc1' \
--header 'Content-Type: application/json' \
--data-raw '{
  "iv": "ksdjfdjksfWWWsksdfjkd",
  "encryptedKey": "kdjfjsdfksdjfjsdhfJJJJsdjfhsdhfyyskdfjksdjf",
  "header": "eyJraWQiOiJrZXlfYjsdfjkkdsfjsdfjsdfIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0",
  "encryptedPayload": "ksdfjdksfAAAWWWWWBBJFJFFFKFJFsjfsdjfksdfndjfjdsfk887",
  "tag": "PT7c70nump_MBePrlTDPIA"
}'
