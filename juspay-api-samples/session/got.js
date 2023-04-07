import got from "got";

const apiKey = "<your_api_key_here>";
const endpoint = "https://api.juspay.in/session";
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
  "options.get_upi_deep_links": true
});


got
  .post(endpoint, {
    json: requestPayload,
    headers: {
      "x-merchantid": credentials.merchantId,
      Authorization: authorization,
      "Content-Type": "application/json",
    },
  })
  .json()
  .then((response) => {
    console.log("Response: ", response);
  });
