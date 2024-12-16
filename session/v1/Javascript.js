import fetch from 'node-fetch';

const apiKey = "<your_api_key>";
const merchantId = "<your_merchant_id>";
const clientId = "<your_client_id>";
const authorization = "Basic " + Buffer.from(apiKey + ":").toString("base64");

var requestPayload = JSON.stringify({
  "order_id": "testing-order-one",
  "amount": "1.0",
  "customer_id": "testing-customer-one",
  "customer_email": "test@mail.com",
  "customer_phone": "98765432",
  "payment_page_client_id": clientId,
  "action": "paymentPage",
  "return_url": "https://shop.merchant.com",
  "description": "Complete your payment",
  "theme": "dark",
  "billing_address_first_name": "John",
  "billing_address_last_name": "wick"
});

var requestOptions = {
  method: 'POST',
  headers: {
    'Authorization': authorization,
    'x-merchantid': merchantId,
    'Content-Type': 'application/json'
  },
  body: requestPayload
};

fetch("https://api.juspay.io/session", requestOptions)
  .then(response => response.text())
  .then(result => console.log(result))
  .catch(error => console.log('error', error));