curl -X POST https://api.juspay.in/customers\
-u your_api_key:\
-H 'x-merchantid: merchant_id'\
-H 'Content-Type: application/x-www-form-urlencoded'\
-d "object_reference_id=customer@gmail.com"\
-d "mobile_number=9988776655"\    
-d "email_address=customer@gmail.com"\
-d "first_name=John"\
-d "last_name=Smith"\
-d "mobile_country_code=91"\
-d"options.get_client_auth_token=true"\


fkvjnvf