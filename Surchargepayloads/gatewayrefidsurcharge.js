var amount = order_reference.amount;
var is_card = payment.method_type == "CARD";
var is_debit_card = payment.card_type == "DEBIT";
var gatewayRefId = payment.gateway_reference_id;
var resp = {};
if (gatewayRefId == "ABC") {
    resp.fixed_surcharge_amount = 40.00;
    resp.surcharge_rate = 0;
    resp.tax_rate = 0;
}
else {
    resp.fixed_surcharge_amount = 20.00;
    resp.surcharge_rate = 0;
    resp.tax_rate = 0;
}
resp;
