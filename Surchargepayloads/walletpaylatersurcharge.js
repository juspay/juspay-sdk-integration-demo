var amount = order_reference.amount;
var method = payment.method;
var is_wallet = payment.method_type == "WALLET";
var resp = {};
resp.fixed_surcharge_amount = null;

if (is_wallet) {
    if (method == "FREECHARGE") {
        resp.surcharge_rate = 7.0;
        resp.tax_rate = 0.0;
    } else {
        resp.surcharge_rate = 1.10;
        resp.tax_rate = 18;
    }
}

resp;
