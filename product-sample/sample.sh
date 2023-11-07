curl --location 'https://api.juspay.in/session' \
--header 'Authorization: Basic base64_encoded_API_KEY' \
--header 'x-merchantid: your_merchant_id' \
--header 'Content-Type: application/json' \
--data '{
    "amount":"1.00",
    "order_id":"unique_order_id",
    "customer_id":"customer_id",
    "customer_phone":"customer_phone",
    "customer_email":"customer_email",
    "payment_page_client_id":"your_client_id",
    "return_url": "https://www.google.com",
    "action":"paymentPage",
    "product_summary": "[[{\"type\":\"text\",\"text\":\"Amount Entered :\",\"color\":\"#032146\",\"fontType\" : \"bold\"},{\"type\":\"space\",\"weight\":1},{\"type\":\"text\",\"text\":\"₹7812.5\",\"fontType\":\"Bold\",\"color\":\"#032146\"}],[{\"type\":\"text\",\"text\":\"Bonus Code WWWLECOME175 has been applied\",\"textSize\":10,\"fontType\":\"SemiBold\",\"color\":\"#000000\"}],[{\"type\":\"space\"}],[{\"type\":\"text\",\"text\":\"GST Charges :\",\"fontType\":\"Bold\",\"color\":\"#032146\"},{\"type\":\"space\",\"weight\":1},{\"type\":\"text\",\"text\":\"₹2187.5\",\"fontType\":\"Bold\"}],[{\"type\":\"text\",\"text\":\"28% on Amount Entered\",\"textSize\":10,\"fontType\":\"SemiBold\",\"color\":\"#000000\"}],[{\"type\":\"divider\",\"thickness\":1,\"color\":\"#D6C190\"}],[{\"type\":\"text\",\"text\":\"Total Pay\",\"textSize\":16,\"fontType\":\"Bold\",\"color\":\"#032146\"},{\"type\":\"space\",\"weight\":1},{\"type\":\"text\",\"text\":\"₹10,000\",\"textSize\":16,\"fontType\":\"Bold\",\"color\":\"#032146\"}],[{\"type\":\"space\"}],[{\"type\":\"background\",\"color\":\"#faefd9\"},{\"type\":\"image\",\"url\":\"https://cdn-icons-png.flaticon.com/512/4213/4213958.png\"},{\"type\":\"text\",\"text\":\"Extra Surprise bonus is auto-applied just for you\",\"textSize\":10,\"fontType\":\"Bold\",\"color\":\"#032146\"}]]"
}'