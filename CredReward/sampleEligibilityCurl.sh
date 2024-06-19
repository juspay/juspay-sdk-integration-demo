curl --location 'http://api.juspay.in/v3/eligibility' \
--header 'authority: sandbox.assets.juspay.in' \
--header 'accept: */*' \
--header 'accept-language: en-GB,en-US;q=0.9,en;q=0.8' \
--header 'cache-control: no-cache' \
--header 'content-type: application/json' \
--header 'origin: http://localhost:8080' \
--header 'sdk-app-name: unknown_appname' \
--header 'sdk-user-agent: Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36' \
--header 'sec-ch-ua: "Not/A)Brand";v="99", "Google Chrome";v="115", "Chromium";v="115"' \
--header 'sec-ch-ua-mobile: ?1' \
--header 'sec-ch-ua-platform: "Web"' \
--header 'sec-fetch-dest: empty' \
--header 'sec-fetch-mode: cors' \
--header 'sec-fetch-site: cross-site' \
--header 'user-agent: Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36' \
--header 'x-feature: eligibility' \
--header 'x-jp-merchant-id: test_merchant' \
--header 'x-merchantid: test_merchant' \
--header 'x-session-id: 865627a7-32d0-4b6d-8b77-a55c1284f129' \
--header 'Authorization: Basic RThGQjJCMDBDODA5NDU3RkE5MzU2RDIxMzI1QUYxRDU6' \
--data '{
    "payment_instrument": [
        {
            "payment_method_type": "UPI",
            "payment_method": "UPI",
            "gateway": "CRED",
            "gateway_reference_id": "test",
            "command_input": {
                "phoneNumber": "8437166180",
                "metadata": {
                    "session_id": "865627a7-32d0-4b6d-8b77-a55c1284f129321",
                    "transaction_amount": 200
                },
                "countryCode": "+91"
            },
            "command": "verify_user"
        },
        {
            "payment_method_type": "CARD",
            "payment_method": "CREDIT",
            "gateway": "CRED",
            "gateway_reference_id": "test",
            "command_input": {
                "phoneNumber": "8437166180",
                "metadata": {
                    "session_id": "865627a7-32d0-4b6d-8b77-a55c1284f129321",
                    "transaction_amount": 200
                },
                "countryCode": "+91"
            },
            "command": "verify_user"
        },
        {
            "payment_method": "CRED",
            "payment_method_type": "WALLET",
            "command": "verify_user",
            "gateway": "CRED",
            "gateway_reference_id": "test",
            "command_input": {
                "platform": "web",
                "os": "web",
                "device": "desktop",
                "countryCode": "+91",
                "phoneNumber": "8437166180",
                "credAppPresent": false,
                "metadata": {
                    "session_id": "865627a7-32d0-4b6d-8b77-a55c1284f129321",
                    "transaction_amount": 2,
                    "isWebSupported": "true"
                }
            }
        }
    ],
    "merchant_id": "test_merchant",
    "customer_id": "8437166180",
    "amount": 1
}'
