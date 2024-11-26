curl --location 'https://sandbox.juspay.in/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'version: 2023-01-01' \
--header 'Authorization: Basic OTgwQjERERCOg==' \
--data-urlencode 'order.order_id=ord1732542728' \
--data-urlencode 'order.customer_id=cth_9VoVezimnRJEG42N' \
--data-urlencode 'merchant_id=yourmerchantId' \
--data-urlencode 'payment_method=SPEI' \
--data-urlencode 'payment_method_type=RTP' \
--data-urlencode 'format=json' \
--data-urlencode 'order.amount=1000' \
--data-urlencode 'order.currency=MXN' \
--data-urlencode 'save_to_locker=false' \
--data-urlencode 'order.customer_email=ebanx@gmail.com' \
--data-urlencode 'order.customer_phone=99588765432' \
--data-urlencode 'order.billing_address_first_name=Juspay' \
--data-urlencode 'order.billing_address_last_name=Technologies' \
--data-urlencode 'order.billing_address_line1=Address line 1' \
--data-urlencode 'order.billing_address_line2=Address line 2' \
--data-urlencode 'order.billing_address_line3=Address line 3' \
--data-urlencode 'order.billing_address_city=City' \
--data-urlencode 'order.billing_address_state=State' \
--data-urlencode 'order.billing_address_country=MX' \
--data-urlencode 'order.billing_address_postal_code=560095' \
--data-urlencode 'order.billing_address_phone=9988775566' \
--data-urlencode 'order.billing_address_country_code_iso=MX' \
--data-urlencode 'order.metadata.JUSPAY%3Agateway_reference_id=EBANXMXN' \
--data-urlencode 'order.gateway_id=1138'
