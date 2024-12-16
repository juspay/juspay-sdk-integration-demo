curl -X POST \
  https://api.juspay.io/txns \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Postman-Token: 080f8d26-14a0-xxxx-xxxx-c762677c1798' \
  -H 'cache-control: no-cache' \
  -d 'order_id=64127725&merchant_id=guest&payment_method_type=UPI&payment_method=UPI&txn_type=UPI_COLLECT&upi_vpa=aman.sharma163%40okicici&format=json&redirect_after_payment=true'