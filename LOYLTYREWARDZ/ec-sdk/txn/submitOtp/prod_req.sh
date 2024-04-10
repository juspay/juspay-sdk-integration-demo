curl --location 'http://api.juspay.in/v2/txns/<txn_uuid>/authenticate' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic xxxxzxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
--data-urlencode 'answer.otp=071978' \
--data-urlencode 'challenge_id=1000012422'
