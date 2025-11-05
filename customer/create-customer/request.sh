curl --location 'https://smartgateway.hdfc.bank.in/customers' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'x-merchantid:<merchant_id>’ \
--header 'Authorization: Basic <api key in base64 format>' \
--data-urlencode 'object_reference_id=ABC23' \
--data-urlencode 'mobile_number=7013486500' \
--data-urlencode 'email_address=test@gmail.com' \
--data-urlencode 'first_name=customerfirstname' \
--data-urlencode 'last_name=lastname'
