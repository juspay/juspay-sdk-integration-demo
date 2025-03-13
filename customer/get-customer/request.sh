curl -X GET \
  https://api.juspay.in/customers/:customerid \
  -u your_api_key:  \
  -H 'x-merchantid: merchant_id'\
  -H 'x-routing-id: customer_1122'\
  -H 'Content-Type: application/x-www-form-urlencoded'\
