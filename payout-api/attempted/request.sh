curl --location 'https://sandbox.juspay.in/payout/merchant/v1.1/orders' \
--header 'x-merchantid: <x-merchantid>' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data '{
    "payload": "eyJhbGciOiJSU0EtT0FFUCIsInR5cCI6IkpXVCIsImVuYyI6IkEyNTZDQkMtSFM1MTIifQ.x88C2GRVLT9501v1Nq49QF83qoVSf7xmibBfBrfJn4sOjI1gy1Gu9R5X9diVf-ST9wSHBwKuM4bW7Vs9VsshcCxtQr0xd6rFCbS-PnM6VwbjOh8Vre-06d3j3dbKFEy_OFVIvqvRIpJxGuTcAXUAoaoJMh_ubykxxQJX_owudksyUMmu0-cEa9QeitIET5P_45mn9EdD6NYsy94gYPucBxhfihvUuNfoQH7VwjsYbIAR9NMkxTPzSqfrfGZC2qq5Emav06b937ZfCcz2ncYpdHCBuJ3oWcW4ZG9WkebpAp3ho5lNHiU22TAawyt5B2LZXHCg_1dIdz7fOu0Nkb7Pow.f8LRRRhuMDti2aD3dkyr7w.JHVovPAX5WsztT0ikR_W2_Po7r-4lPRBN69Flv_F9JOQExSrZOYZr0cwXHuThoUhmkxVbvP886xtDgKPbosKUve8pn4k0ujGsVy--ptt5Zici3XEFwmY_m51L3qi_BzmqCBDCTAqXRpkLblyJfAEP-Apdq0956jDe2jwO2KuDly1P29SLcL4rVGTz6244hDCjvCN-JR3sFCTNLN6fFbMOEAPcR2TBEJ5KVDeM_wrdWmdfRp24HPVtVYHA6rE5W2zX_o6a2UeJGApgwKGRZx_u_SLWUrmMP9X_5l8HTjuphbxdVEkSBbZPgBi16ec8PEL8xNvSPtHbY5hSGPgmPJiN6l_4Ht5C8revwUb2OBQcMXxU_WrxvYo8iz8JQAjxM1uDDARJORvuSzbpxi09zJx2QtT6wKNZcFxzfOAHdFZuLhPI0HnamFQcmE1QOAbYhyycrsN918bNesCuJVrpvTOOEaROfbVTZpP3wfpbjf2B93OTV0hNerlQ4zF-A-vSodZ2w164bnq6j.KAUUlWrSXo7VKwlmyseyU8MthpPSUjqpbAyYo1wgNEM",
    "kid": "JuspayKID", 
    "sid": "JuspaySID", 
    "format": "compact"
}'
