var amount = order_reference.amount;
var upi_app_name = payment.upi_app_name;
var is_upi = payment.method_type == "UPI";
var resp = {};
resp.fixed_surcharge_amount = null;

if (is_upi) {
    if (upi_app_name == "PHONEPE") {
        resp.surcharge_rate = 3.0;
        resp.tax_rate = 18;
    }
    else {
        resp.surcharge_rate = 1.10;
        resp.tax_rate = 18;
    }
}
resp;
