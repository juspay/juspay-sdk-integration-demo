curl --location 'https://sandbox.juspay.io/session' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--header 'Content-Type: application/json' \
--header 'x-merchantid: merchant_id' \
--header 'x-customerid: customer_id' \
--header 'Authorization: Basic MjMzQTJBRjQ2REI0NTNCOTQ0Q0JBMUFCNDlGOTIyOg==' \
--data-raw '{
    "order_id": " testing-order-one",
    "amount": "10.0",
    "customer_id": "testing-customer-one",
    "customer_email": "test@mail.com",
    "customer_phone": "8604613494",
    "payment_page_client_id": "your_client_id",
    "action": "paymentPage",
    "currency": "INR",
    "return_url": "https://shop.merchant.com",
    "description": "Complete your payment",
    "first_name": "John",
    "last_name": "wick"

}
'