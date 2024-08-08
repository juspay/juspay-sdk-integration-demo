var amount = order_reference.amount
var is_net_banking = payment.method_type == "NB";
var is_hdfc = payment.method == "NB_HDFC"
var is_icici = payment.method == "NB_ICICI"

var resp = {};
resp.tax_rate = 18;
resp.fixed_surcharge_amount = null;
resp.surcharge_rate = 2.25;

if (is_net_banking) {
    resp.surcharge_rate = null;
    if (is_hdfc || is_icici) {
        resp.fixed_surcharge_amount = 18;
    }
    else {
        resp.fixed_surcharge_amount = 15;
    }
}
resp;
