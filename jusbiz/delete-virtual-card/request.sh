curl --location 'https://sandbox.biz.juspay.in/ardra/vt/deleteCard/v2' \
--header 'KeyId: <key Id>>' \
--header 'Content-Type: application/json' \
--header 'X-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data '{

    "payoutId": "ZELeD2yQF4",
    "action":"CANCEL"
}'