curl --location 'https://sandbox.biz.juspay.in/ardra/vt/provision/v2' \
--header 'KeyId: <key Id>>' \
--header 'Content-Type: application/json' \
--header 'X-merchantid: <merchant id>' \
--header 'Authorization: Basic (b64 encoded API key)' \
--data '{
    "payoutId": "Juspay123456789",
    "orderAmount": "20",
    "gst": "1",
    "action": "Create",
    "startDate": "2024-04-23",
    "endDate": "2024-05-01",
    "cardAlias": "{to be taken from JusBiz Dashboard}",
    "expenseCategoryId":"{to be taken from JusBiz Dashboard}",
    "currency": "INR",
    "isCardImageRequired": true,
    "rules": {
        "blockPayments": [
            "ATM"
        ],
        "amountRange": {
            "min": "3",
            "max": "21"
        },
         "exactAmountApply": [
            "1"
         ],
        "mccBlock": [
            {
                "min": "5013",
                "max": "6051"
            }
        ]
    },
  // below is a sample set of fields supported for Travel Segment  
  
  "Traveller Name": "Rahul Sharma",
  "Ticket Number": "0987654321098",
  "Ticket Issued Date": "2026-10-15",
  "Original Issued Ticket Number": "0987654321098",
  "Exchange Ticket Number 1": "0987654321099",
  "Refund Notice Number": "",
  "Travel Agency Code": "TA001",
  "Travel Agency Name": "ABC Travel Services",
  "Passenger Name Record Reference": "PNR7X9K2",
  "Booking Reference Number": "BK-2026-45678",
  "Merchant Reference Number": "MER-789012",
  "Travel Obligation Number": "TO-2026-001",
  "Number of Sector": "2",
  "Routing": "BOM-DEL-LHR",
  "Trip Departure Date": "2026-11-10",
  "Trip Destination Code": "LHR",
  "Trip Destination City": "London",
  "Trip Destination Country": "United Kingdom",
  "Trip Overall Class": "Economy",
  "Total Discount Amount": "1500.00",
  "Total Gross Amount": "85000.00",
  "Total Net Amount": "83500.00",
  "Employee ID/Number": "EMP10245",
  "GL Number": "GL-510020",
  "Cost Center Code": "CC-MUM-001",
  "Client Reference 1": "CORP-REF-001",
  "Client Reference 2": "PROJECT-TRAVEL",
  "Client Reference 3": "DEPT-FINANCE",
  "Client Reference 4": "REGION-WEST",
  "Client Reference 5": "CLIENT-REF-005",
  "Client Reference 6": "CLIENT-REF-006",
  "Client Reference 7": "CLIENT-REF-007",
  "Client Reference 8": "CLIENT-REF-008",
  "Client Reference 9": "CLIENT-REF-009",
  "Client Reference 10": "CLIENT-REF-010"
}'
