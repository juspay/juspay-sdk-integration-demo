curl -X POST \
  https://api.juspay.io/customers/cst_wexxxxsfdkl/bank-accounts \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -u your_api_key:
  -d 'bank_code=JP_X&command=create&ifsc=HDFC092343&account_number=40002323422&beneficiary_name=test&metadata.param1=value1&metadata.param2=value2'
