curl --location 'https://sandbox.juspay.in/v2/txns/mozt4zuA4fQkQBrCPKb/capture' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Authorization: Basic RTk4OEM4Mxxxxxxxxxxxxxxxxjc5RDkwQjg1QUI3Og==' \
--data-urlencode 'metadata={"SIMPL": {
    "delivery_address": {
        "line1": "24158",
        "line2": "6468 Ross Mills Apt. 815",
        "city": "West Bryan",
        "state": "Stravenue",
        "country": "Burundi",
        "pincode": "400611"
    },
    "delivery_3PL": "xyz",
    "delivery_status": "delivered",
    "delivery_timestamp": "3442353",
    "delivery_geolocation": {
        "lat": "20.3575411",
        "long": "72.9370882"
    },
    "delivery_location": "Burundi Stravenue ",
    "otp_verified": "true"
}}