curl --location 'https://sandbox.juspay.in/txns' \
   --header 'Content-Type: application/x-www-form-urlencoded' \
   --header 'Authorization: Basic N0JBRDA4OUExxxxxxxxxxxxxNDlCNjY3QTVCMUQzM0Q6' \
   --data-urlencode 'order_id=o1704808129' \
   --data-urlencode 'merchant_id=azharamin' \
   --data-urlencode 'payment_method_type=WALLET' \
   --data-urlencode 'payment_method=SIMPL_SOD' \
   --data-urlencode 'redirect_after_payment=true' \
   --data-urlencode 'format=json' \
   --data-urlencode 'pre_auth_enabled=true'