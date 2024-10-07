$ curl https://api-test.lotuspay.com/v1/sources \
    -u sk_test_XjIHowXWSI23uvjepz2X82: \
    -d type="nach_debit" \
    -d nach_debit[amount_maximum]=10000 \
    -d nach_debit[date_first_collection]="2020-01-01" \
    -d nach_debit[frequency]="MNTH" \
    -d redirect[return_url]="https://www.lotuspay.com/" \
    -d bank_account="BA004433221AA"
