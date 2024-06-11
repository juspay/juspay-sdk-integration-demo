var amount = order_reference.amount;
var is_card = payment.method_type == "CARD";
var is_debit_card = payment.card_type == "DEBIT";
var gatewayRefId = payment.gateway_reference_id;
var resp = {
    surcharge_rate: 0.0,
    fixed_surcharge_amount: 0.0,
    cgst: 0.0,
    sgst: 0.0
}

if (gatewayRefId == "74") {
    resp.fixed_surcharge_amount = 40.00;
} else if (gatewayRefId == "106") {
    if (is_cards) {
        resp.fixed_surcharge_amount = 10.00;
        resp.surcharge_rate = 1.2;
    } else {
        resp.surcharge_rate = 1.5;

    }
}
else {
    resp.fixed_surcharge_amount = 20.00;
}
resp;
