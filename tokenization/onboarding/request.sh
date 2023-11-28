curl --location --request POST 'https://api.juspay.in/tokenization/onboarding' \
--header 'Authorization: Basic base_64_encoded_api_key==' \
--header 'version: 2023-06-30' \
--header 'x-merchantid: <merchant id> \
--header 'Content-Type: application/json' \
--data-raw '{
  "associateId": "rohit_juspay",
  "testMode": true,
  "companyDetails": {
    "legalName": "Partner's merchant Legal Name",
    "tradeName": "Partner's merchant trade Name",
    "websiteURL": "Partner's merchant URL",
    "contactEmail": "Partner's merchant Email",
    "businessIdentificationType": "",
    "businessIdentificationValue": ""
  },
 "flow": "ALT_ID",
 "network": "VISA"
}'