curl -X GET \
  'https://smartgateway.hdfcbank.com/customers/:customer_id?options.get_client_auth_token=true' \
-u your_api_key:  \
-H 'x-merchantid: merchant_id'