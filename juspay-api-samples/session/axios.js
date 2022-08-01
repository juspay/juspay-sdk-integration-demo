const axios = require("axios");

const endpoint = "https://api.juspay.in/session";
const merchantId = "<your_merchant_id>";
const apiKey = "<your_api_key_here>";
const clientId = "<your_client_id>";
const authorization = "Basic " + Buffer.from(apiKey + ":").toString("base64");

let requestPayload = JSON.stringify({
  order_id: "testing-order-one",
  amount: "1.0",
  customer_id: "testing-customer-one",
  customer_email: "test@mail.com",
  customer_phone: "9876543210",
  payment_page_client_id: clientId,
  action: "paymentPage",
  return_url: "https://shop.merchant.com",
  description: "Complete your payment",
  theme: "dark",
  first_name: "John",
  last_name: "wick",
});

let config = {
  method: "post",
  url: endpoint,
  headers: {
    Authorization: authorization,
    "x-merchantid": merchantId,
    "Content-Type": "application/json",
  },
  data: requestPayload,
};

axios(config)
  .then(function (response) {
    console.log(JSON.stringify(response.data));
  })
  .catch(function (error) {
    console.log(error);
  });
