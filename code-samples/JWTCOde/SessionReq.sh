curl --location --request POST 'https://smartgatewayuat.hdfcbank.com/v4/session' \
--header 'x-merchantid: testhdfc1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "header": "hbGciOiJIUzI1NiIsInR5cCI6Ikp",
    "encryptedKey": "NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9",
    "iv": "iIsInR5c",
    "encryptedPayload": "DkwIiwibmFtZSI6IkpvaG4gRG9lI",
    "tag": "2QT4fwpMeJf36POk6y"
}'
