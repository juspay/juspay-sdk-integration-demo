curl -X GET \
  https://api.juspay.in/customers/:customerid \
  -u your_api_key:  \
  -H 'x-merchantid: merchant_id'\
  -H 'Content-Type: application/x-www-form-urlencoded'\