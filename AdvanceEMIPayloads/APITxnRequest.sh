// For a new card transaction
curl -X POST https://api.juspay.in/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "payment_method=VISA" \
-d "card_number=4242424242424242" \
-d "card_exp_month=10" \
-d "card_exp_year=20" \
-d "name_on_card=Name" \
-d "card_security_code=111" \
-d "save_to_locker=true" \
-d "tokenize=true" \
-d "redirect_after_payment=true" \
-d "format=json"\
-d "is_emi=true" \
-d "emi_bank=HDFC" \
-d "emi_tenure=3" \
-d "emi_type=STANDARD_EMI"\
-d "offers=[3a8fc1dc-2ace-4f15-8bae-16b376785692]"                                


//For a stored card transaction
curl -X POST https://api.juspay.in/txns \
-d "order_id=:order_id" \
-d "merchant_id=:merchant_id" \
-d "payment_method_type=CARD" \
-d "card_token=:card_token" \
-d "card_security_code=111" \ #optional field for CVV less supported transactions
-d "redirect_after_payment=true" \
-d "format=json"\
-d "is_emi=true" \
-d "emi_bank=HDFC" \
-d "emi_tenure=3" \
-d "emi_type=STANDARD_EMI"\
-d "offers=[3a8fc1dc-2ace-4f15-8bae-16b376785692]"
