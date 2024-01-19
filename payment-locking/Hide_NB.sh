--data-raw '{
    "order_id": "testing-order-one",
    "amount": "1.0",
    "customer_id": "testing-customer-one",
    "customer_email": "test@mail.com",
    "customer_phone": "9876543210",
    "payment_page_client_id": "your_client_id",
    "action": "paymentPage",
    "return_url": "https://shop.merchant.com",
    "description": "Complete your payment",
    "first_name": "John",
    "last_name": "wick",
    "payment_filter": {
       "allowDefaultOptions" : true,
       "options": [
         {
           "paymentMethodType": "NB",
           "enable" : false
         }
       ]
     }
}'
