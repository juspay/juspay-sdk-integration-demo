$ curl https://api-test.lotuspay.com/v1/sources \
    -u sk_test_XjIHowXWSI23uvjepz2X82: \
    -d type="nach_debit" \
    -d nach_debit[amount_maximum]=10000 \
    -d nach_debit[debtor_agent_code]="ICIC" \
    -d nach_debit[debtor_account_name]="AMIT JAIN" \
    -d nach_debit[debtor_account_number]="12345678" \
    -d nach_debit[debtor_account_type]="savings" \
    -d nach_debit[frequency]="MNTH" \
    -d nach_debit[reference1]="CUSTOMER_123"
