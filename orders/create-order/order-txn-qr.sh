curl --location --request POST 'https://api.juspay.in/orders' \
--header 'version: 2018-10-25' \
--header 'Authorization: Basic N0JBRDA4OUExRjYwNEYwREEyNDlCNjY3QTVCMUQzM0Q6' \
--form 'order_id="HD-1707740261"' \
--form 'amount="1"' \
--form 'currency="INR"' \
--form 'customer_id="cth_w2gbGjGi8BUkLgCo"' \
--form 'customer_email="krishna.gprasad@juspay.in"' \
--form 'customer_phone="7093125824"' \
--form 'description="NA"' \
--form 'product_id="5"' \
--form 'return_url="http://www.google.com/"' \
--form 'options.get_client_auth_token="true"' \
--form 'metadata.JUSPAY:gateway_reference_id="testmode"' \
–-form 'udf10="RiderQR"' \
–-form 'order_fullfillment_threshold_in_mins="60"' \
--form 'options.get_upi_qr="true"'
