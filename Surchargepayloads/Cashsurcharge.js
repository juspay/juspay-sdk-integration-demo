var amount = order_reference.amount;
var is_cash = payment.method_type == "CASH";
var resp = {};
var surcharge_max_amount = 399;

if (is_cash) {
    if (amount <= surcharge_max_amount) {
        resp.surcharge_rate = 5.2632;
        resp.tax_rate = 0;
        resp.fixed_surcharge_amount = 40.00;
    }
}
resp;
