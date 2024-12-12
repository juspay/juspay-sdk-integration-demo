$ curl https://api-test.lotuspay.com/v1/subscriptions \
   -u sk_test_XjIHowXWSI23uvjepz2X82: \
   -d amount=10000 \
   -d count=2 \
   -d day_of_month=23 \
   -d interval="month" \
   -d mandate="MD0011DD22RR33" \
   -d name="Order 123" \
   -d start_date="2018-12-02"
