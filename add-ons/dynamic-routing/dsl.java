def order = [orderId: "orderId", amount: 5000.00, currency:"INR", preferredGateway: "AXIS", 
              udf1:"web", udf2: "desktop", udf3: "flight_booking", udf4: "", udf5: "", 
              udf6: "", udf7: "", udf8: "", udf9: "", udf10: ""]

def txn = [ txnId: "txnId", isEmi: true, emiBank: "HDFC", emiTenue: 6 ]

def payment = [cardBin: "524368", cardIssuer: "HDFC Bank", cardType: "CREDIT", cardBrand: "MASTERCARD", 
                paymentMethod: "MASTERCARD", paymentMethodType: "CARD", cardIssuerCountry: "INDIA", authType:"OTP"]

// use the below for randomization
long currentTimeMillis = _milliseconds_since_epoch_in_UTC;

// all the above variables are available to the DSL