curl --location 'http://localhost:8080/txns' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic XXX' \
--data-urlencode 'merchant_id=XXX' \
--data-urlencode 'order_id=XXX' \
--data-urlencode 'payment_method_type=CARD' \
--data-urlencode 'format=json' \
--data-urlencode 'card_number=5522XXXXX3142' \
--data-urlencode 'card_exp_month=12' \
--data-urlencode 'card_exp_year=2024' \
--data-urlencode 'card_security_code=XXX' \
--data-urlencode 'redirect_after_payment=true' \
--data-urlencode 'name_on_card=jason' \
--data-urlencode 'payment_method=MASTERCARD' \
--data-urlencode 'transient_info={"deviceInformation": {"acceptHeaders":"text/html,application/xhtml+xml,application/xml;q=0.9,
image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
"colourDepth": 20,"javaEnabled": false,"javaScriptEnabled": true,"cookieEnabled": false,
"language": "en-US","screenHeight": 100,"screenWidth": 36,"ipAddress": "127.30.0.1",
"userAgent": "Mozilla/5.0+(Macintosh;+Intel+Mac+OS+X+10_15_7)+AppleWebKit/537.36+(KHTML,+like+Gecko)+Chrome/105.0.0.0+Safari/537.36",
"timeZone": 330,"acceptContent": "application/xml","threeDSecureChallengeWindowSize": "FULL_SCREEN",
"mobilePhoneModel": "RMX2202"}}' \
