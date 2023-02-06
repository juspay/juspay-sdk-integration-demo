Map<String, dynamic> getProcessPayload(amount) {
  // NOTE: This part of code should be handled in the server NOT THE CLIENT APP
  // Merchant should call the session API on their server and return the sdk_payload (sample paylaod hard coded below for reference)

  return {
    "requestId": "12398b5571d74c3388a74004bc24370c",
    "service": "in.juspay.hyperpay",
    "payload": {
      "clientId": "your_client_id", // replace with your client id
      "amount": amount,
      "merchantId": "picasso", // replace with your merchant id
      "clientAuthToken": "tkn_xxxxxxxxxxxxxxxxxxxxx",
      "clientAuthTokenExpiry": "2022-03-12T20:29:23Z",
      "environment": "sandbox",
      "lastName": "wick",
      "action": "paymentPage",
      "customerId": "testing-customer-one",
      "returnUrl": "https://shop.merchant.com",
      "currency": "INR",
      "firstName": "John",
      "customerPhone": "9876543210",
      "customerEmail": "test@mail.com",
      "orderId": "testing-order-one",
      "description": "Complete your payment"
    }
  };
}
