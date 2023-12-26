curl --location 'https://api.juspay.in/customers/:customer_id/virtual-accounts' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic SlVTUEFZOmVkYzEXXXXXXXXXXExOGExMjRjMA==' \
--data '{
    "virtual_account_reference": "vaRef1",
    "type": "ACCOUNT_IFSC",
    "parent_reference_id": "parentAccount1"
}'
