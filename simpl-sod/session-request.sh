curl --location --request POST 'https://sandbox.juspay.in/session' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic 82Q19002******==' \
--data-raw '{
    "order_id": "ref_939",
    "amount": "100.0",
    "customer_id": "cth_pKL9ayw75febC1Dd",
    "customer_email": "test@mail.com",
    "customer_phone": "9986028298",
    "payment_page_client_id": "sugar",
    "action": "paymentPage",
    "return_url": "http://www.juspay.in",
    "description": "Complete your payment",
    "first_name": "John",
    "last_name": "wick",
    "product_id": "test123",
    "quantity": "1",
    "merchant_id": "merchant_success",
    "currency": "INR",
    "metadata.SIMPL:gateway_reference_id": "simpl_sod",
    "simpl_additional_info": {
        "shipping_address": {
            "line1": "54999",
            "line2": "300 Randolph Parkways Apt. 902",
            "city": "Shauntown",
            "state": "Drives",
            "country": "French Guiana",
            "pincode": "400611"
        },
        "merchant_params": {
            "email": "shshh@gamil.com",
            "first_txn_date": "2019-07-17",
            "user_loyalty_level": "Gold",
            "user_blacklist_flag": "true",
            "request_ori_page": "precheckout",
            "seller_identifier": "123",
            "seller_vintage": "4",
            "seller_category": "PRIME",
            "additional_order_id": "12345",
            "first_name": "Simpl",
            "last_name": "Simpl",
            "aggregator_flow_ori": "PP"
        }
    }
}'