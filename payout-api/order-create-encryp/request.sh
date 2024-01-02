curl --location 'https://sandbox.juspay.in/payout/merchant/v1.1/orders' \
--header 'x-merchantid: <merchant id>' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data '{
    "payload": "eyJlbmMiOiJBMTI4Q0xxxxxxxxxxxxwiYWxnIjoiUlNBLU9BRVAiLCJraWQiOiJhbWF6b25rZXkxIn0.ZOkZg-CxCvVbC-uX-QphJW0LWBKymxFEF2deYncqYwC-7py8NgjSehE7HufNfQdHe6YE3i2a_veugtO6K1MzpsHltH8N4he-cJ8zuFsnSIaFeDnLL-AyCXcztwIAx7eaJM36lJea_V1mPqFdIbDVO7M1Pi7QIPzzM3r4bK7E3yPxI2mVvqMai86OToHWaXH8vP7HEKoGXlTf_Ldeb93-uOpGzyrP836NbsP7lYm5XdsXeNOHnaAP645XTBUGvYPd1huFne91vPmxIiEZnaYAFcyxeDDwsc-yWiLyNGUSo8P8Ukw-8WJvMcbMAL4BcX8pLDQcacegGfGpx_M9943JOg.Ge18ShQX6dpAdJFJeeZyfQ.u2bTacQhX6rc5WdSkXEzFyyqwXQiOtm_LmA03fvleHi-dAoVefPmahP2lBzwQNt6NK_uVoztRvtfqpGR1yPLuZ7havx0NtWeIJIBCHJWnDyBYF7ECnrXbNbWj3XHdUq8N20c50aWEW3Iz9YjbUNizg.M3I3FfCNdFDhIal4VqccNw",
    "kid": "kid", //Reference to Juspay private key
    "sid": "sid", //Reference to Merchant public key
    "format": "compact"
}'
