curl POST \
https://api.juspay.in/orders \
 -H 'Authorization: Basic <base64 of key:>' \
 -H 'Content-Type: application/x-www-form-urlencoded'\
 -d "order_id=152664118690577-910" \
 -d "amount=5.00" \
 -d "currency=INR" \
 -d "customer_id=test_juspay" \
 -d "customer_email=test@gmail.com" \
 -d "customer_phone=987654321" \
 -d "billing_address_first_name=Parth" \
 -d "billing_address_city=Bengaluru" \
 -d "shipping_address_city=Mumbai" \
 -d "mandate.amount_rule=VARIABLE" \
 -d "shipping_address_first_name=Parth" \
 -d "options.create_mandate=REQUIRED" \
 -d "mandate_max_amount=1000.00"
